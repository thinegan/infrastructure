provider "aws" {
  region = "us-east-1"
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "devVPC"

  cidr = "10.38.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets  = ["10.38.1.0/20", "10.38.16.0/20", "10.38.32.0/20"]
  private_subnets = ["10.38.48.0/20", "10.38.64.0/20", "10.38.80.0/20"]

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    Name = "overridden-name-public"
  }

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "devVPC"
    Terraform = "true"
    Environment = "dev"
  }
}