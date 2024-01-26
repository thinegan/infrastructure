terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.4.0"
    }
    codefresh = {
      source  = "codefresh-io/codefresh"
      version = ">= 0.4.2" # Optional but recommended; replace with latest semantic version
    }
  }
  required_version = ">= 1.5.7"
}

