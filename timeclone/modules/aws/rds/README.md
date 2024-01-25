# AWS RDS Terraform module

Terraform module which creates RDS resources on AWS

## Usage Example

```hcl
module "rds_postgres_employee" {
  source = "modules/aws/rds"

  name              = "employee"
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

output "rds_postgres_employee" {
  description = "RDS info"
  value       = module.rds_postgres_employee
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [terraform-aws-modules/rds/aws.this](https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/5.3.0) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | the name of the rds | `string` | `""` | yes |
| <a name="input_engine"></a> [engine](#input\_engine) | rds engine | `string` | `""` | yes |
| <a name="input_engine_version"></a> [engine_version](#input\_engine_version) | rds engine version | `string` | `""` | yes |
| <a name="input_family"></a> [family](#input\_family) | rds engine family DB Parameter Group | `string` | `""` | yes |
| <a name="input_instance_class"></a> [instance_class](#input\_instance_class) | instance_class size | `string` | `""` | yes |
| <a name="input_allocated_storage"></a> [allocated_storage](#input\_allocated_storage) | storage size | `string` | `""` | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment | `string` | `""` | yes |
| <a name="input_jdbc_username"></a> [jdbc_username](#input\_jdbc_username) | jdbc_username | `string` | `""` | yes |
| <a name="input_jdbc_password"></a> [jdbc_password](#input\_jdbc_password) | jdbc_password | `string` | `""` | yes |
| <a name="input_port"></a> [port](#input\_port) | port | `string` | `""` | yes |
| <a name="input_pod"></a> [tags](#input\_pod) | A mapping of tags to assign to the rds | `map(string)` | `{}` | yes |


## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_endpoint"></a> [instance_endpoint](#output\_instance_endpoint) | rds instance endpoint |
| <a name="output_instance_name"></a> [instance_name](#output\_instance_name) | rds db name |
| <a name="output_instance_address"></a> [instance_address](#output\_instance_address) | rds instance address |
| <a name="output_rds_identifier"></a> [rds_identifier](#output\_rds_identifier) | rds identifier |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

