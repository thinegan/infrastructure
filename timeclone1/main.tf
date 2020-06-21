module "iam" {
  source = "./modules/iam"
}

module "ec2" {
  source = "./modules/ec2"
}

terraform {
  backend "remote" {
    hostname      = "app.terraform.io"
    organization  = "timeclone"

    workspaces {
      name = "state-migration"
    }
  }
}

// AWS Provider
provider "aws" {
  version                 = "2.67"
  region                  = "us-east-1"
}
