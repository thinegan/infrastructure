provider "aws" {
  version  = "~> 2.0"
  region   = "us-east-1"
}

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform-staging-state-storage"
    dynamodb_table = "terraform-staging-state-locks"
    region         = "us-east-1"
    key            = "timeclone/eks/stag-eks-tgen/0-kubernetes/terraform.tfstate"
  }
}

data "terraform_remote_state" "stag_eks_tgen" {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "terraform-staging-state-storage"
    dynamodb_table = "terraform-staging-state-locks"
    region         = "us-east-1"
    key            = "timeclone/eks/stag-eks-tgen/terraform.tfstate"
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

