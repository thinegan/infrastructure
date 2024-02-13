terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.4.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0"
    }
    argocd = {
      source  = "oboukili/argocd"
      version = "~> 5.6.0"
    }
  }
  required_version = ">= 1.5.7"
}
