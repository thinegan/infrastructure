# ###################################################################################################
# ## ref : https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/latest
# ## ref : https://github.com/terraform-aws-modules/terraform-aws-rds/tree/master/examples/complete-postgres
# ###################################################################################################
module "rds_postgres_supplier" {
  source = "../../../../../modules/aws/rds"

  name              = "supplier"
  engine            = "postgres"
  engine_version    = "15"
  family            = "postgres15"
  instance_class    = "db.t3.micro"
  environment       = "staging"
  allocated_storage = 10
  jdbc_username     = local.jdbc_username
  jdbc_password     = local.jdbc_password
  port              = 5432
  pod               = "DEVOPS"
}

output "rds_postgres_supplier" {
  description = "RDS output info"
  value       = module.rds_postgres_supplier
}

# Update to readable DNS Endpoint
resource "cloudflare_record" "endpoint" {
  zone_id = local.zone_id
  name    = module.rds_postgres_supplier.rds_identifier
  value   = module.rds_postgres_supplier.instance_address
  type    = "CNAME"
}

output "rds_endpoint" {
  description = "RDS Endpoint"
  sensitive   = true
  value       = "${module.rds_postgres_supplier.rds_identifier}.${local.domain}"
}
