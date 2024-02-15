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
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0"
    }
    bcrypt = {
      source  = "viktorradnai/bcrypt"
      version = "~> 0.1.2"
    }
  }
  required_version = ">= 1.5.7"
}
