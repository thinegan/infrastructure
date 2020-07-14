data "terraform_remote_state" "timeclone" {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "terraform-staging-state-storage"
    dynamodb_table = "terraform-staging-state-locks"
    region         = "us-east-1"
    key            = "timeclone/network/terraform.tfstate"
  }
}


# # module "vpc" {
# #   source = "../vpc"
# # }

# data "aws_eks_cluster" "cluster" {
#   name = module.dev_eks_ugen.cluster_id
# }

# data "aws_eks_cluster_auth" "cluster" {
#   name = module.dev_eks_ugen.cluster_id
# }


# module "vpc" {
#   source = "./modules/vpc"
# }

# locals {
#   private_subnet_ids = [
#     module.vpc.module.vpc.aws_subnet.private[0].id,
#     module.vpc.module.vpc.aws_subnet.private[1].id,
#     module.vpc.module.vpc.aws_subnet.private[2].id,
#   ]

#   public_subnet_ids  = [
#     module.vpc.module.vpc.aws_subnet.public[0].id,
#     module.vpc.module.vpc.aws_subnet.public[1].id,
#     module.vpc.module.vpc.aws_subnet.public[2].id,
#   ]
#   eks_subnet_ids     = concat(local.public_subnet_ids, local.private_subnet_ids)
# }

# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.cluster.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
#   token                  = data.aws_eks_cluster_auth.cluster.token
#   load_config_file       = false
#   version                = "~> 1.9"
# }

# module "dev_eks_ugen" {
#   source          = "terraform-aws-modules/eks/aws"
#   cluster_name    = "DEV-EKS-UGen"
#   cluster_version = "1.16"
#   # subnets         = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]
#   # vpc_id          = "vpc-1234556abcdef"
#   subnets         = locals.eks_subnet_ids
#   vpc_id          = module.vpc.module.vpc.aws_vpc.this[0].id

#   worker_groups = [
#     {
#       instance_type = "t2.micro"
#       asg_max_size  = 2
#     }
#   ]
# }
