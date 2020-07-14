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


# # module "vpc" {
# #   source = "../vpc"
# # }

data "aws_eks_cluster" "cluster" {
  name = module.dev_eks_ugen.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.dev_eks_ugen.cluster_id
}


# module "vpc" {
#   source = "./modules/vpc"
# }

locals {
  # private_subnet_ids = [
  #   data.terraform_remote_state.devVPC.outputs.private_subnets
  # ]

  # public_subnet_ids  = [
  #   data.terraform_remote_state.devVPC.outputs.public_subnets
  # ]

  private_subnet_ids = data.terraform_remote_state.devVPC.outputs.private_subnets
  public_subnet_ids  = data.terraform_remote_state.devVPC.outputs.public_subnets

  eks_subnet_ids     = concat(local.public_subnet_ids, local.private_subnet_ids)
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
  cluster_name    = "DEV-EKS-UGen"
  cluster_version = "1.16"
  # subnets         = locals.eks_subnet_ids
  subnets         = concat(data.terraform_remote_state.devVPC.outputs.private_subnets, data.terraform_remote_state.devVPC.outputs.public_subnets)
  vpc_id          = data.terraform_remote_state.devVPC.outputs.vpc_id

  worker_groups = [
    {
      instance_type = "t2.micro"
      asg_max_size  = 2
    }
  ]
}


# module "eks" {
#   source       = "../.."
#   cluster_name = local.cluster_name
#   subnets      = module.vpc.private_subnets

#   tags = {
#     Environment = "test"
#     GithubRepo  = "terraform-aws-eks"
#     GithubOrg   = "terraform-aws-modules"
#   }

#   vpc_id = module.vpc.vpc_id

#   worker_groups = [
#     {
#       name                          = "worker-group-1"
#       instance_type                 = "t2.small"
#       additional_userdata           = "echo foo bar"
#       asg_desired_capacity          = 2
#       additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
#     },
#     {
#       name                          = "worker-group-2"
#       instance_type                 = "t2.medium"
#       additional_userdata           = "echo foo bar"
#       additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
#       asg_desired_capacity          = 1
#     },
#   ]

#   worker_additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]
#   map_roles                            = var.map_roles
#   map_users                            = var.map_users
#   map_accounts                         = var.map_accounts
# }
