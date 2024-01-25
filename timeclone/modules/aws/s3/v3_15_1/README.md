# AWS S3 bucket Terraform module

Terraform module which creates S3 bucket on AWS.

## Usage Example

```hcl
module "s3_example" {
  source = "modules/aws/s3/v3_15_1"

  name        = "example-bucket"
  pod         = "DEVOPS"
  environment = "staging"
}

output "s3_example" {
  description = "The name of the bucket."
  value       = module.s3_example
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
| [terraform-aws-modules/s3-bucket/aws.this](https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/3.15.1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | the name of the bucket | `string` | `""` | yes |
| <a name="input_access"></a> [access](#input\_access) | The canned ACL to apply. Conflicts with grant | `string` | `""` | yes |
| <a name="input_pod"></a> [pod](#input\_pod) | A mapping of tags to assign to the bucket | `string` | `""` | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | A mapping of tags to assign to the bucket | `string` | `""` | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_s3_bucket_id"></a> [s3_bucket_id](#output\_s3\_bucket\_id) | The name of the bucket |
| <a name="output_s3_bucket_arn"></a> [s3_bucket_arn](#output\_s3\_bucket\_arn) | The ARN of the bucket |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

