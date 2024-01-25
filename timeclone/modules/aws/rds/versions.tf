terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.4.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.5.7"
}
