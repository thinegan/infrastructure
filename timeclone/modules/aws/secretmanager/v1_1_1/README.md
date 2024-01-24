# AWS Secrets Manager Terraform module

Terraform module which creates AWS Secrets Manager resources.

## Usage Example

```hcl
locals {
  prefix = "devops"
  kmsid  = data.terraform_remote_state.devops_staging_kms.outputs.kms_timeclone_dev.key_arn
  tags = {
    Pod         = "DEVOPS"
    Environment = "staging"
    Terraform   = "true"
  }
}

module "secrets_manager_example" {
  source      = "modules/aws/secretmanager/v1_1_1"
  name        = "${local.prefix}-example"
  tags        = local.tags
  kms_key_id  = local.kmsid
  description = "Example API token, email and domain zoneid"
}

output "secrets_manager_example" {
  value = module.secrets_manager_example
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
| [terraform-aws-modules/secrets-manager/aws.this](https://registry.terraform.io/modules/terraform-aws-modules/secrets-manager/aws/1.1.1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | name of the secret manager | `string` | `""` | yes |
| <a name="input_description"></a> [description](#input\_allow\_readonly) | description of the secret manager | `string` | `""` | yes |
| <a name="input_kms_key_id"></a> [kms_key_id](#input\_kms\_key\_id) | kms id to use | `string` | `""` | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags | `map(string)` | `{}` | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID/ARN of the secret |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

