output "id" {
  description = "The ID of the VPC"
  value       = module.this.vpc_id
}

output "cidr" {
  description = "List of cidr_blocks of subnets"
  value       = module.this.vpc_cidr_block
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.this.public_subnets
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.this.private_subnets
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.this.database_subnets
}

output "azs" {
  description = "A list of availability zones names or ids in the region"
  value       = module.this.azs
}
