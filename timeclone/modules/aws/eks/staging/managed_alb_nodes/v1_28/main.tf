data "aws_ami" "worker" {
  filter {
    name   = "name"
    values = [join("", ["amazon-eks-node-", local.eks_version, "-v*"])]
  }
  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}

locals {
  eks_version = 1.28

  tags = {
    Service     = var.name
    Environment = var.environment
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }
}


#####################################################################################
# EKS Module
# ref : https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
#####################################################################################
module "this" {
  source                         = "terraform-aws-modules/eks/aws"
  version                        = "19.16.0"
  cluster_name                   = var.name
  cluster_version                = local.eks_version
  enable_irsa                    = true # Enable OIDC Provider 
  subnet_ids                     = concat(var.private_subnet_ids, var.public_subnet_ids)
  vpc_id                         = var.vpcid
  cluster_endpoint_public_access = true

  # Add this to avoid issues with AWS Load balancer controller
  # "error":"expect exactly one securityGroup tagged kubernetes.io/cluster/xxx
  # https://github.com/terraform-aws-modules/terraform-aws-eks/issues/1986
  # Related to using nginx ingress controller
  node_security_group_tags = {
    "kubernetes.io/cluster/${var.name}" = null
  }

  # Note : Cloudwatch $cost (AmazonCloudWatch PutLogEvents)
  # Refer to doc for enabling logs and audit reports
  # cluster_enabled_log_types = ["api","audit","authenticator"]
  # expected enabled_cluster_log_types.0 to be one of [api audit authenticator controllerManager scheduler]
  cluster_enabled_log_types = []

  # Bugs Ref : https://github.com/terraform-aws-modules/terraform-aws-eks/issues/2635
  cluster_addons = {
    coredns = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "PRESERVE"
      timeouts = {
        create = "4m"
        delete = "4m"
      }
    }
    kube-proxy = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "PRESERVE"
    }
    vpc-cni = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "PRESERVE"
      configuration_values = jsonencode({
        env = {
          # Reference docs https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
          WARM_IP_TARGET = "10"
        }
      })
    }
    aws-ebs-csi-driver = {
      service_account_role_arn    = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.name}-oidc-amazon_ebs_csi_driver"
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "PRESERVE"
    }
  }

  # External encryption key
  create_kms_key = false
  cluster_encryption_config = {
    resources        = ["secrets"]
    provider_key_arn = var.kmsid
  }

  iam_role_additional_policies = {
    additional = aws_iam_policy.additional.arn
  }

  # Extend cluster security group rules
  cluster_security_group_additional_rules = {
    ingress_nodes_ephemeral_ports_tcp = {
      description                = "Nodes on ephemeral ports"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "ingress"
      source_node_security_group = true
    }
    # Test: https://github.com/terraform-aws-modules/terraform-aws-eks/pull/2319
    ingress_source_security_group_id = {
      description              = "Ingress from another computed security group"
      protocol                 = "tcp"
      from_port                = 22
      to_port                  = 22
      type                     = "ingress"
      source_security_group_id = aws_security_group.additional.id
    }
  }

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    # Test: https://github.com/terraform-aws-modules/terraform-aws-eks/pull/2319
    ingress_source_security_group_id = {
      description              = "Ingress from another computed security group"
      protocol                 = "tcp"
      from_port                = 22
      to_port                  = 22
      type                     = "ingress"
      source_security_group_id = aws_security_group.additional.id
    }
  }

  #######################################################################################################################################
  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t2.micro", "t2.small", "t3.large"]

    attach_cluster_primary_security_group = true
    vpc_security_group_ids                = [aws_security_group.additional.id]
    iam_role_additional_policies = {
      additional = aws_iam_policy.additional.arn
    }
  }

  eks_managed_node_groups = {

    # Working Node Group
    "${var.name}-${var.gen1_node_group}" = {
      min_size       = var.gen1_min_size
      max_size       = var.gen1_max_size
      desired_size   = var.gen1_desired_size
      subnet_ids     = var.private_subnet_ids
      instance_types = var.gen1_instance_type
      capacity_type  = var.gen1_capacity_type

      ebs_optimized = true
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 30
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 150
            encrypted             = true
            kms_key_id            = var.kmsid
            delete_on_termination = true
          }
        }
      }
      labels = {
        scaling     = "true"
        Environment = var.environment
        GithubRepo  = "terraform-aws-eks"
        GithubOrg   = "terraform-aws-modules"
      }
    }
  }

  #######################################################################################################################################
  # Gives Access to our IAM Roles/Users to EKS Cluster
  # aws-auth configmap setup
  #######################################################################################################################################

  manage_aws_auth_configmap = true
  # create_aws_auth_configmap = true
  aws_auth_accounts = local.map_accounts
  aws_auth_users    = local.map_users

  tags = {
    Environment = var.environment
    pod         = var.pod
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }
}

########################################################################################
# Start of resource tagging logic to update the provided vpc and its subnets with 
# the necessary tags for eks to work
# The toset() function is actually multiplexing the resource block, one for every 
# item in the set. It is what allows for setting a tag on each of the subnets in the vpc.
########################################################################################
resource "aws_ec2_tag" "private_subnet_cluster_tag" {
  for_each    = toset(var.private_subnet_ids)
  resource_id = each.value
  key         = "kubernetes.io/cluster/${var.name}"
  value       = "shared"
}

resource "aws_ec2_tag" "public_subnet_cluster_tag" {
  for_each    = toset(var.public_subnet_ids)
  resource_id = each.value
  key         = "kubernetes.io/cluster/${var.name}"
  value       = "shared"
}

################################################################################
# Desired Size Hack (no of desired instance)
# https://github.com/bryantbiggs/eks-desired-size-hack

# Increasing EKS Cluster instances
# ref issue: https://github.com/terraform-aws-modules/terraform-aws-eks/issues/835
# Please note : instance scaling required 2-step to avoid,
# Minimum capacity X can't be greater than desired size X fail error"
# Step 1: Increase the desired_size (< max_size) and apply
# Step 2: Increase the min_size ( <= desired_size) and apply
################################################################################

resource "null_resource" "update_gen1_desired_size" {
  triggers = {
    desired_size = var.gen1_desired_size
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]

    # Note: this requires the awscli to be installed locally where Terraform is executed
    command = <<-EOT
      aws eks update-nodegroup-config \
        --cluster-name ${module.this.cluster_name} \
        --nodegroup-name ${element(split(":", module.this.eks_managed_node_groups["${var.name}-${var.gen1_node_group}"].node_group_id), 1)} \
        --scaling-config desiredSize=${var.gen1_desired_size}
    EOT
  }
}

##########################################################
# Security Group(SG) for ELB/ALB
# Due to limit of numbers of SG that can be apply to ELB/ALB, 
# all ELB/ALB (HTTP/HTTPS) can be shared using the same SG
##########################################################

resource "aws_security_group" "central_elb_sg" {
  name        = "${var.name}-elb-web-traffic"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpcid

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-ELB-SG"
  }
}

output "central_elb_sg" {
  value = aws_security_group.central_elb_sg
}

resource "aws_security_group_rule" "Elb_Join_cluster_primary_sgid" {
  description              = "Allow EKS Cluster to communicate with ELB"
  from_port                = 0
  protocol                 = "tcp"
  security_group_id        = module.this.cluster_primary_security_group_id
  source_security_group_id = aws_security_group.central_elb_sg.id
  to_port                  = 65535
  type                     = "ingress"
}

# Usually for sysadmin internal debugging
resource "aws_security_group" "additional" {
  name_prefix = "${var.name}-additional"
  vpc_id      = var.vpcid
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      "10.38.0.0/16",   # Within same VPC network connection!
      "172.20.0.0/16",  # Within same cluster connection!
      "192.168.0.0/16", # Within HomeLab VPN connection!
    ]
  }
}

resource "aws_iam_policy" "additional" {
  name = "${var.name}-additional"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

