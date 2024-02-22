terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.4.0"
    }
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.27.0"
    }
  }
  required_version = ">= 1.5.7"
}
