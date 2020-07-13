provider "aws" {
  region = "us-east-1"
}

# data "aws_security_group" "default" {
#   name   = "default"
#   vpc_id = module.vpc.vpc_id
# }

# module "vpc" {
#   source = "terraform-aws-modules/vpc/aws"

#   name = "devVPC"

#   cidr = "10.38.0.0/16"

#   azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
#   public_subnets  = ["10.38.0.0/20", "10.38.16.0/20", "10.38.32.0/20"]
#   private_subnets = ["10.38.48.0/20", "10.38.64.0/20", "10.38.80.0/20"]

#   enable_ipv6 = true
#   enable_nat_gateway    = true
#   single_nat_gateway    = true
#   enable_dns_hostnames  = true

#   # Setup NACL - Public
#   public_dedicated_network_acl = true
#   public_inbound_acl_rules = concat(
#     local.network_acls["default_inbound"],
#     local.network_acls["public_inbound"],
#   )
#   public_outbound_acl_rules = concat(
#     local.network_acls["default_outbound"],
#     local.network_acls["public_outbound"],
#   )

#   # Setup NACL - Private
#   private_dedicated_network_acl = true

#   tags = {
#     Owner       = "user"
#     Environment = "dev"
#   }

#   public_subnet_tags = {
#     "kubernetes.io/role/elb" = "1"
#   }

#   private_subnet_tags = {
#     "kubernetes.io/role/internal-elb" = "1"
#   }

#   vpc_tags = {
#     Name = "devVPC"
#     Terraform = "true"
#     Environment = "dev"
#   }
# }

# output "devVPC" {
#   value = module.vpc
# }


# # NACL Rules
# locals {
#   network_acls = {
#     default_inbound = [
#       { #Ephemeral Ports -TCP
#         rule_number = 900
#         rule_action = "allow"
#         from_port   = 1024
#         to_port     = 65535
#         protocol    = "tcp"
#         cidr_block  = "0.0.0.0/0"
#       },
#     ]
#     default_outbound = [
#       { #Ephemeral Ports -TCP
#         rule_number = 900
#         rule_action = "allow"
#         from_port   = 32768
#         to_port     = 65535
#         protocol    = "tcp"
#         cidr_block  = "0.0.0.0/0"
#       },
#     ]
#     public_inbound = [
#       { #HTTP
#         rule_number = 100
#         rule_action = "allow"
#         from_port   = 80
#         to_port     = 80
#         protocol    = "tcp"
#         cidr_block  = "0.0.0.0/0"
#       },
#       { #HTTPS
#         rule_number = 110
#         rule_action = "allow"
#         from_port   = 443
#         to_port     = 443
#         protocol    = "tcp"
#         cidr_block  = "0.0.0.0/0"
#       },
#       { #SSH
#         rule_number = 120
#         rule_action = "allow"
#         from_port   = 22
#         to_port     = 22
#         protocol    = "tcp"
#         cidr_block  = "0.0.0.0/0"
#       },
#       { #LDAP
#         rule_number = 130
#         rule_action = "allow"
#         from_port   = 636
#         to_port     = 636
#         protocol    = "tcp"
#         cidr_block  = "0.0.0.0/0"
#       },
#       { #NTP
#         rule_number = 140
#         rule_action = "allow"
#         from_port   = 123
#         to_port     = 123
#         protocol    = "udp"
#         cidr_block  = "0.0.0.0/0"
#       },
#       { #DNS
#         rule_number = 150
#         rule_action = "allow"
#         from_port   = 53
#         to_port     = 53
#         protocol    = "udp"
#         cidr_block  = "0.0.0.0/0"
#       },
#       { #SMTP
#         rule_number = 160
#         rule_action = "allow"
#         from_port   = 25
#         to_port     = 25
#         protocol    = "tcp"
#         cidr_block  = "0.0.0.0/0"
#       },
#       { #SMTPS
#         rule_number = 170
#         rule_action = "allow"
#         from_port   = 587
#         to_port     = 587
#         protocol    = "tcp"
#         cidr_block  = "0.0.0.0/0"
#       },
#       { #SMTPS Google
#         rule_number = 180
#         rule_action = "allow"
#         from_port   = 465
#         to_port     = 465
#         protocol    = "tcp"
#         cidr_block  = "0.0.0.0/0"
#       },
#       { #ICMP
#         rule_number = 500
#         rule_action = "allow"
#         icmp_code   = -1
#         icmp_type   = -1
#         protocol    = "icmp"
#         cidr_block  = "0.0.0.0/0"
#       },
#     ]
#     public_outbound = [
#       { #HTTP
#         rule_number = 100
#         rule_action = "allow"
#         from_port   = 80
#         to_port     = 80
#         protocol    = "tcp"
#         cidr_block  = "0.0.0.0/0"
#       },
#       { #HTTPS
#         rule_number = 110
#         rule_action = "allow"
#         from_port   = 443
#         to_port     = 443
#         protocol    = "tcp"
#         cidr_block  = "0.0.0.0/0"
#       },
#       { #SSH
#         rule_number = 120
#         rule_action = "allow"
#         from_port   = 22
#         to_port     = 22
#         protocol    = "tcp"
#         cidr_block  = "0.0.0.0/0"
#       },
#       { #LDAP
#         rule_number = 130
#         rule_action = "allow"
#         from_port   = 636
#         to_port     = 636
#         protocol    = "tcp"
#         cidr_block  = "0.0.0.0/0"
#       },
#       { #NTP
#         rule_number = 140
#         rule_action = "allow"
#         from_port   = 123
#         to_port     = 123
#         protocol    = "udp"
#         cidr_block  = "0.0.0.0/0"
#       },
#       { #DNS
#         rule_number = 150
#         rule_action = "allow"
#         from_port   = 53
#         to_port     = 53
#         protocol    = "udp"
#         cidr_block  = "0.0.0.0/0"
#       },
#       { #SMTP
#         rule_number = 160
#         rule_action = "allow"
#         from_port   = 25
#         to_port     = 25
#         protocol    = "tcp"
#         cidr_block  = "0.0.0.0/0"
#       },
#       { #SMTPS
#         rule_number = 170
#         rule_action = "allow"
#         from_port   = 587
#         to_port     = 587
#         protocol    = "tcp"
#         cidr_block  = "0.0.0.0/0"
#       },
#       { #SMTPS Google
#         rule_number = 180
#         rule_action = "allow"
#         from_port   = 465
#         to_port     = 465
#         protocol    = "tcp"
#         cidr_block  = "0.0.0.0/0"
#       },
#       { #ICMP
#         rule_number = 500
#         rule_action = "allow"
#         icmp_code   = -1
#         icmp_type   = -1
#         protocol    = "icmp"
#         cidr_block  = "0.0.0.0/0"
#       },
#     ]
#   }
# }
