// AWS Provider
provider "aws" {
  version  = "2.67"
  region   = "us-east-1"
  # assume_role {
  #   role_arn = "arn:aws:iam::204995021158:user/terraform-exec"
  # }
}

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform-staging-state-storage"
    dynamodb_table = "terraform-staging-state-locks"
    region         = "us-east-1"
    key            = "timeclone/s3/terraform.tfstate"
    # role_arn       = "arn:aws:iam::204995021158:user/terraform-exec"
  }
}
