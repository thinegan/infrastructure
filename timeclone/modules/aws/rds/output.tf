# RDS endpoint url + port
output "instance_endpoint" {
  description = "rds instance endpoint"
  value       = module.this.db_instance_endpoint
}

# RDS DB name
output "instance_name" {
  description = "rds db name"
  value       = module.this.db_instance_name
}

# RDS endpoint url
output "instance_address" {
  description = "rds instance address"
  value       = module.this.db_instance_address
}

# RDS endpoint url
output "rds_identifier" {
  description = "rds identifier"
  value       = join("-", [var.environment, var.engine, var.name])
}
