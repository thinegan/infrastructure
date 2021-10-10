// Updates
provider "aws" {
  # version  = "~> 3.0"
  profile = "default"
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "terraform-stag-state-storage"
    key            = "global/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "stag-terraform-state-table"
  }
}

resource "aws_s3_bucket" "bucket" {
    bucket = "terraform-stag-state-storage"
    versioning {
        enabled = true
    }
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }
    object_lock_configuration {
        object_lock_enabled = "Enabled"
    }
    tags = {
        Name = "S3 Remote Terraform State Store"
    }
}

resource "aws_dynamodb_table" "terraform-lock" {
    name           = "stag-terraform-state-table"
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "LockID"
    attribute {
        name = "LockID"
        type = "S"
    }
    tags = {
        "Name" = "DynamoDB Terraform State Lock Table"
    }
}
