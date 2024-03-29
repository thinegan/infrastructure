terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.4.0"
    }
    codefresh = {
      source  = "codefresh-io/codefresh"
      version = ">= 0.4.2"
    }
  }
  required_version = ">= 1.5.7"
}
