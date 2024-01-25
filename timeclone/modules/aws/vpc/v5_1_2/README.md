# AWS VPC Terraform module

Terraform module which creates VPC resources on AWS.

## Usage Example

```hcl
module "stagingVPC" {
  source = "modules/aws/vpc/v5_1_2"

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
| [terraform-aws-modules/vpc/aws.this](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/5.1.2) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | the name of the VPC | `string` | `""` | yes |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | cidr ip block | `string` | `""` | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | A environment of tags to assign to the vpc | `string` | `""` | yes |
| <a name="input_azs"></a> [azs](#input\_azs) | A list of availability zones specified as argument to this module | `list(string)` | `[]` | yes |
| <a name="input_public_subnets"></a> [public_subnets](#input\_public\_subnets) | List of IDs of public subnets | `list(string)` | `[]` | yes |
| <a name="input_private_subnets"></a> [private_subnets](#input\_private\_subnets) | List of IDs of private subnets | `list(string)` | `[]` | yes |
| <a name="input_database_subnets"></a> [database_subnets](#input\_database\_subnets) | List of IDs of database subnets | `list(string)` | `[]` | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID/ARN of the secret |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

