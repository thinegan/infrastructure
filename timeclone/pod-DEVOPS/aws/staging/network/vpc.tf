###########################################################################################
# Note: You cannot create a VPC peering connection between VPCs that have matching or overlapping IPv4 or IPv6 CIDR blocks. 
# If you have multiple IPv4 CIDR blocks, you can't create a VPC peering connection if any of the CIDR blocks overlap, 
# even if you intend to use only the non-overlapping CIDR blocks or only IPv6 CIDR blocks.
# Try to sure to use uncommon cidr range. Avoid (192.168.*, 10.10.*) common cidr range.

# environment: development/staging/production
# others - all private subnets will route their Internet traffic through this single NAT gateway
# production - One NAT Gateway per availability zone to ensure high availibility

# ref : https://www.colocationamerica.com/ip-calculator
# Network Bits : */20
# Subnet Mask : 255.255.240.0
# Max Number of Subnets : 14
# Max Number of Hosts per subnet : 4094
###########################################################################################
module "stagingVPC" {
  source = "../../../../modules/aws/vpc/v5_1_2"

  name             = "stagingVPC"
  environment      = "staging"
  cidr             = "10.38.0.0/16"
  azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets   = ["10.38.0.0/20", "10.38.16.0/20", "10.38.32.0/20"]
  private_subnets  = ["10.38.48.0/20", "10.38.64.0/20", "10.38.80.0/20"]
  database_subnets = ["10.38.96.0/20", "10.38.112.0/20", "10.38.128.0/20"]
}

output "stagingVPC" {
  value = module.stagingVPC
}
