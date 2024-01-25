# AWS ECR Terraform module

Terraform module which creates AWS ECR resources.

## Usage Example


### Private Repository

```hcl
module "ecr_example" {
  source         = "modules/aws/ecr/v1_6_0"
  name           = "crytera/templatesample"
  allow_readonly = ["arn:aws:iam::012345678901:root"]
  pod            = "DEVOPS"
  environment    = "staging"
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
| [terraform-aws-modules/ecr/aws.this](https://registry.terraform.io/modules/terraform-aws-modules/ecr/aws/1.6.0) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the repository | `string` | `""` | yes |
| <a name="input_allow_readonly"></a> [allow\_readonly](#input\_allow\_readonly) | The ARNs of the aws account that have read access to the repository | `list(string)` | `[]` | yes |
| <a name="input_pod"></a> [pod](#input\_pod) | A mapping of tags to assign pod team | `string` | `""` | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | A mapping of tags to assign environment | `string` | `""` | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecr_repository_arn"></a> [ecr\_repository\_arn](#output\_ecr\_repository\_arn) | Full ARN of the repository |
| <a name="output_ecr_repository_registry_id"></a> [ecr\_repository\_registry\_id](#output\_ecr\_repository\_registry\_id) | The registry ID where the repository was created |
| <a name="output_ecr_repository_url"></a> [ecr\_repository\_url](#output\_ecr\_repository\_url) | The URL of the repository |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

