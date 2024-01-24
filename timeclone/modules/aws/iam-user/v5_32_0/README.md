# AWS IAM user example

Configuration in this directory creates IAM user with a random password, a pair of IAM access/secret keys.

## Usage Example

```hcl
locals {
  prefix = "de" //Data Engineering
  tags = {
    Pod         = "DE"
    Environment = "staging"
    Terraform   = "true"
  }
}

module "user_EveBrown" {
  source = "modules/aws/iam-user/v5_32_0"

  username = "EveBrown756"
  fullname = "Eve Brown"
  email    = "EveBrown756@crytera.com"
  tags     = local.tags

  // Attach with all relevant Policy group(s)
  groups = [
    module.group_dataengineer_advance.group_name
  ]

  // Custom policy dedicated for this user only
  policy_arns = [
    module.iam_staging_s3_readonly_timeclone_dev1.arn
  ]
}

# ECR Output info
output "user_EveBrown" {
  value = module.user_EveBrown
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
| [terraform-aws-modules/iam-user/aws.this](https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/5.32.0/examples/iam-user) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_username"></a> [username](#input\_username) | the name of the user | `string` | `""` | yes |
| <a name="input_email"></a> [email](#input\_email) | the email of the user | `string` | `""` | yes |
| <a name="input_fullname"></a> [fullname](#input\_fullname) | The user fullname | `string` | `""` | yes |
| <a name="input_forcedreset"></a> [forcedreset](#input\_forcedreset) | A mapping of tags to assign to the bucket | `number` | `0` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags | `map(string)` | `{}` | yes |
| <a name="input_policy_arns"></a> [policy_arns](#input\_policy_arns) | The custom policy ARNs to be attached to the user | `list(string)` | `[]` | no |
| <a name="input_groups"></a> [groups](#input\_groups) | The user groups to be attached to the user | `list(string)` | `[]` | yes |


## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_user_name"></a> [iam_user_name](#output\_iam\_user\_name) | The user's name |
| <a name="output_iam_user_arn"></a> [iam_user_arn](#output\_iam\_user\_arn) | The ARN assigned by AWS for this user |
| <a name="output_iam_user_groups"></a> [iam_user_groups](#output\_iam\_user\_groups) | The groups assigned for this user |
| <a name="output_keybase_password_decrypt_command"></a> [keybase_password_decrypt_command](#output\_keybase\_password\_decrypt\_command) | Decrypt user password command (require keybase) |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

