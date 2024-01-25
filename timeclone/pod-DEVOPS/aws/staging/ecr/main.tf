// AWS Provider
provider "aws" {
  alias  = "staging"
  region = "us-east-1"
}

provider "aws" {
  alias   = "production"
  region  = "us-east-1"
  profile = "production1"
}

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform-stag-state-storage"
    key            = "timeclone/pod-DEVOPS/aws/staging/ecr/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "stag-terraform-state-table"
  }
}
