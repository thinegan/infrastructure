// AWS Provider
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
    key            = "timeclone/eks/stag-eks-tgen/terraform.tfstate"
  }
}
