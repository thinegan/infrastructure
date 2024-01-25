
locals {
  # NACL Rules
  network_acls = {
    default_inbound = [
      { #Ephemeral Ports -TCP
        rule_number = 900
        rule_action = "allow"
        from_port   = 1024
        to_port     = 65535
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      { #Ephemeral Ports -UDP
        rule_number = 910
        rule_action = "allow"
        from_port   = 1024
        to_port     = 65535
        protocol    = "udp"
        cidr_block  = "0.0.0.0/0"
      },
    ]
    default_outbound = [
      { #Ephemeral Ports -TCP
        rule_number = 900
        rule_action = "allow"
        from_port   = 1024
        to_port     = 65535
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      { #Ephemeral Ports -UDP
        rule_number = 910
        rule_action = "allow"
        from_port   = 1024
        to_port     = 65535
        protocol    = "udp"
        cidr_block  = "0.0.0.0/0"
      },
    ]
    public_inbound = [
      { #HTTP
        rule_number = 100
        rule_action = "allow"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      { #HTTPS
        rule_number = 110
        rule_action = "allow"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      { #SSH
        rule_number = 120
        rule_action = "allow"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      { #LDAP
        rule_number = 130
        rule_action = "allow"
        from_port   = 636
        to_port     = 636
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      { #NTP
        rule_number = 140
        rule_action = "allow"
        from_port   = 123
        to_port     = 123
        protocol    = "udp"
        cidr_block  = "0.0.0.0/0"
      },
      { #DNS
        rule_number = 150
        rule_action = "allow"
        from_port   = 53
        to_port     = 53
        protocol    = "udp"
        cidr_block  = "0.0.0.0/0"
      },
      { #SMTP
        rule_number = 160
        rule_action = "allow"
        from_port   = 25
        to_port     = 25
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      { #SMTPS
        rule_number = 170
        rule_action = "allow"
        from_port   = 587
        to_port     = 587
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      { #SMTPS Google
        rule_number = 180
        rule_action = "allow"
        from_port   = 465
        to_port     = 465
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      { #ICMP
        rule_number = 500
        rule_action = "allow"
        icmp_code   = -1
        icmp_type   = -1
        protocol    = "icmp"
        cidr_block  = "0.0.0.0/0"
      },
      { #OpenVPN
        rule_number = 190
        rule_action = "allow"
        from_port   = 943
        to_port     = 943
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      { #OpenVPN
        rule_number = 195
        rule_action = "allow"
        from_port   = 945
        to_port     = 945
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      { #OpenVPN
        rule_number = 200
        rule_action = "allow"
        from_port   = 1194
        to_port     = 1194
        protocol    = "udp"
        cidr_block  = "0.0.0.0/0"
      },
      { #Datadog
        rule_number = 205
        rule_action = "allow"
        from_port   = 8126
        to_port     = 8126
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
    ]
    public_outbound = [
      { #HTTP
        rule_number = 100
        rule_action = "allow"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      { #HTTPS
        rule_number = 110
        rule_action = "allow"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      { #SSH
        rule_number = 120
        rule_action = "allow"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      { #LDAP
        rule_number = 130
        rule_action = "allow"
        from_port   = 636
        to_port     = 636
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      { #NTP
        rule_number = 140
        rule_action = "allow"
        from_port   = 123
        to_port     = 123
        protocol    = "udp"
        cidr_block  = "0.0.0.0/0"
      },
      { #DNS
        rule_number = 150
        rule_action = "allow"
        from_port   = 53
        to_port     = 53
        protocol    = "udp"
        cidr_block  = "0.0.0.0/0"
      },
      { #SMTP
        rule_number = 160
        rule_action = "allow"
        from_port   = 25
        to_port     = 25
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      { #SMTPS
        rule_number = 170
        rule_action = "allow"
        from_port   = 587
        to_port     = 587
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      { #SMTPS Google
        rule_number = 180
        rule_action = "allow"
        from_port   = 465
        to_port     = 465
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      { #ICMP
        rule_number = 500
        rule_action = "allow"
        icmp_code   = -1
        icmp_type   = -1
        protocol    = "icmp"
        cidr_block  = "0.0.0.0/0"
      },
      { #OpenVPN
        rule_number = 190
        rule_action = "allow"
        from_port   = 943
        to_port     = 943
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      { #OpenVPN
        rule_number = 195
        rule_action = "allow"
        from_port   = 945
        to_port     = 945
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      { #OpenVPN
        rule_number = 200
        rule_action = "allow"
        from_port   = 1194
        to_port     = 1194
        protocol    = "udp"
        cidr_block  = "0.0.0.0/0"
      },
      { #Datadog
        rule_number = 205
        rule_action = "allow"
        from_port   = 8126
        to_port     = 8126
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
    ]
  }

  NatGateway = var.environment == "production" ? false : true
}


###################################################################################################
## ref : https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/5.1.2
###################################################################################################
module "this" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name             = var.name
  cidr             = var.cidr
  azs              = var.azs
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets

  enable_ipv6             = false
  enable_nat_gateway      = true
  enable_dns_hostnames    = true
  map_public_ip_on_launch = true

  # If single_nat_gateway = true, then all private subnets will route their Internet traffic through this single NAT gateway. 
  # The NAT gateway will be placed in the first public subnet in your public_subnets block.
  # (single_nat_gateway = true) costsaving if on the staging/dev env 
  # (single_nat_gateway = false) One NAT Gateway per availability zone to ensure high availibility on production env
  single_nat_gateway = local.NatGateway

  # Setup NACL - Public
  public_dedicated_network_acl = true

  public_inbound_acl_rules = concat(
    local.network_acls["default_inbound"],
    local.network_acls["public_inbound"],
  )
  public_outbound_acl_rules = concat(
    local.network_acls["default_outbound"],
    local.network_acls["public_outbound"],
  )

  # Setup NACL - Private
  private_dedicated_network_acl = true

  #ref: https://repost.aws/knowledge-center/eks-vpc-subnet-discovery
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  vpc_tags = {
    Name        = var.name
    Terraform   = "true"
    Environment = var.environment
  }
}
