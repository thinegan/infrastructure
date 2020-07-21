provider "aws" {
  version  = "2.67"
  region   = "us-east-1"
}

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform-staging-state-storage"
    dynamodb_table = "terraform-staging-state-locks"
    region         = "us-east-1"
    key            = "timeclone/eks/0-kubernetes/terraform.tfstate"
  }
}

data "terraform_remote_state" "dev_eks_ugen" {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "terraform-staging-state-storage"
    dynamodb_table = "terraform-staging-state-locks"
    region         = "us-east-1"
    key            = "timeclone/eks/terraform.tfstate"
  }
}

data "terraform_remote_state" "timeclone_iam" {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "terraform-staging-state-storage"
    dynamodb_table = "terraform-staging-state-locks"
    region         = "us-east-1"
    key            = "timeclone/iam/terraform.tfstate"
  }
}

data "aws_eks_cluster" "staging" {
  name = data.terraform_remote_state.dev_eks_ugen.outputs.dev_eks_ugen.cluster_id
}

data "aws_eks_cluster_auth" "staging" {
  name = data.terraform_remote_state.dev_eks_ugen.outputs.dev_eks_ugen.cluster_id
}

# NOTE: Takes sometimes for the kubernetes provider to work (DNS Propagation)
provider "kubernetes" {
  host                   = data.aws_eks_cluster.staging.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.staging.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.staging.token
  load_config_file       = false
  version                = "~> 1.9"
}

