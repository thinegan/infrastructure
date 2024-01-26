// AWS Provider
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform-stag-state-storage"
    key            = "timeclone/pod-DEVOPS/cloudflare/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "stag-terraform-state-table"
  }
}

data "terraform_remote_state" "devops_staging_secretmanager" {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "terraform-stag-state-storage"
    dynamodb_table = "stag-terraform-state-table"
    region         = "us-east-1"
    key            = "timeclone/pod-DEVOPS/aws/staging/secretmanager/terraform.tfstate"
  }
}


