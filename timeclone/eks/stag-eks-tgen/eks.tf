data "terraform_remote_state" "devVPC" {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "terraform-staging-state-storage"
    dynamodb_table = "terraform-staging-state-locks"
    region         = "us-east-1"
    key            = "timeclone/vpc/terraform.tfstate"
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_ami" "worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-1.15-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}

locals {
  cluster_name       = "dev_eks_ugen"
  private_subnet_ids = data.terraform_remote_state.devVPC.outputs.private_subnets
  public_subnet_ids  = data.terraform_remote_state.devVPC.outputs.public_subnets
  eks_subnet_ids     = concat(local.public_subnet_ids, local.private_subnet_ids)
}

data "aws_eks_cluster" "cluster" {
  name = module.dev_eks_ugen.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.dev_eks_ugen.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.9"
}

module "dev_eks_ugen" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = "1.15"
  subnets         = local.eks_subnet_ids
  vpc_id          = data.terraform_remote_state.devVPC.outputs.vpc_id

  tags = {
    Environment = "dev"
    pod = "devops"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

# # Spot
#   worker_groups_launch_template = [
#     {
#       name                    = "spot-1"
#       override_instance_types = ["t2.medium", "t3.medium"]
#       key_name                = "cycle1"
#       spot_instance_pools     = 2
#       asg_max_size            = 3
#       asg_desired_capacity    = 2
#       kubelet_extra_args      = "--node-labels=node.kubernetes.io/lifecycle=spot"
#       disk_size               = 50
#       subnets                 = local.private_subnet_ids
#     }
#   ]

# OnDemand
  node_groups = {
    ugen_nodepool1 = {
      desired_capacity = 2
      min_capacity     = 2
      max_capacity     = 10
      disk_size        = 50
      subnets          = local.private_subnet_ids

      instance_type = "t2.medium"
      k8s_labels = {
        Environment = "development"
        GithubRepo  = "terraform-aws-eks"
        GithubOrg   = "terraform-aws-modules"
        Name        = local.cluster_name
      }
      additional_tags = {
        ExtraTag = "nodepool1"
        Name     = local.cluster_name
      }
    }
  }

  worker_additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  map_roles                            = var.map_roles
  map_users                            = var.map_users
  map_accounts                         = var.map_accounts

}

output "dev_eks_ugen" {
  value = module.dev_eks_ugen
}

output "config_map_aws_auth" {
  description = "A kubernetes configuration to authenticate to this EKS cluster."
  value       = module.dev_eks_ugen.config_map_aws_auth
}

##########################################################
# Setup AWS Identity Providers - Managed IAM Role
# Require external thumbprint.sh to generate CA Thumbprint 
##########################################################

data "local_file" "signature_read" {
    filename = "signature.txt"
}

output "mysignature" {
  value = data.local_file.signature_read
}

# Enabling IAM Roles for Service Accounts
resource "aws_iam_openid_connect_provider" "oidc_eks_ugen" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.local_file.signature_read.content]
  url             = module.dev_eks_ugen.cluster_oidc_issuer_url
}

output "oidc_eks_ugen" {
  value = aws_iam_openid_connect_provider.oidc_eks_ugen
}

##########################################################
# Security Group(SG) for ELB
# Due to limit of numbers of SG that can be apply to ELB, 
# all ELB (HTTP/HTTPS) can be shared using the same SG
##########################################################

resource "aws_security_group" "central_elb_sg" {
  name        = "eks_sgen_elb_web_traffic"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.terraform_remote_state.devVPC.outputs.vpc_id

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
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.cluster_name}-ELB-SG"
  }
}

output "central_elb_sg" {
  value = aws_security_group.central_elb_sg
}

resource "aws_security_group_rule" "Elb_Join_" {
  description              = "Allow node to communicate with ELB"
  from_port                = 0
  protocol                 = "tcp"
  security_group_id        = module.dev_eks_ugen.worker_security_group_id
  source_security_group_id = aws_security_group.central_elb_sg.id
  to_port                  = 65535
  type                     = "ingress"

  depends_on = [
    module.dev_eks_ugen,
  ]
}

resource "aws_security_group_rule" "Elb_Join_cluster_primary_sgid" {
  description              = "Allow Primary Cluster to communicate with ELB"
  from_port                = 0
  protocol                 = "tcp"
  security_group_id        = module.dev_eks_ugen.cluster_primary_security_group_id
  source_security_group_id = aws_security_group.central_elb_sg.id
  to_port                  = 65535
  type                     = "ingress"

  depends_on = [
    module.dev_eks_ugen,
  ]
}

resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = data.terraform_remote_state.devVPC.outputs.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      data.terraform_remote_state.devVPC.outputs.devVPC_cidr,
    ]
  }
}
