// AWS Provider
provider "aws" {
  profile = "default" // staging
  region  = "us-east-1"
}

provider "aws" {
  alias   = "production"
  region  = "us-east-1"
  profile = "production1"
}

locals {
  prefix = "de" //Data Engineering
  tags = {
    Pod         = "DE"
    Environment = "staging"
    Terraform   = "true"
  }
}

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform-stag-state-storage"
    key            = "timeclone/pod-DE/aws/staging/iam/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "stag-terraform-state-table"
  }
}

data "terraform_remote_state" "devops_staging_iam" {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "terraform-stag-state-storage"
    dynamodb_table = "stag-terraform-state-table"
    region         = "us-east-1"
    key            = "timeclone/pod-DEVOPS/aws/staging/iam/terraform.tfstate"
  }
}
