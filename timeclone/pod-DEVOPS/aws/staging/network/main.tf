// AWS Provider
provider "aws" {
  region = "us-east-1"
  ignore_tags {
    key_prefixes = ["kubernetes.io/cluster/"]
  }
}

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform-stag-state-storage"
    key            = "timeclone/pod-DEVOPS/aws/staging/network/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "stag-terraform-state-table"
  }
}
