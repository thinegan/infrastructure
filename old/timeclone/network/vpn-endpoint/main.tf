// AWS Provider
provider "aws" {
  version  = "~> 2"
  region   = "us-east-1"
}

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

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform-staging-state-storage"
    dynamodb_table = "terraform-staging-state-locks"
    region         = "us-east-1"
    key            = "timeclone/network/vpn-endpoint/terraform.tfstate"
  }
}
