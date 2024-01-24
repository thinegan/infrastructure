# AWS IAM Policy example

Configuration in this directory creates IAM policies.

## Usage Example

```hcl
module "iam_policy_example_allow" {
  source = "modules/aws/iam-policy/v5_32_0"

  name        = "secretsmanager-example-allow"
  description = "Allow Team to Manage Policy"
  tags        = local.tags
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowReadWriteDE",
      "Effect": "Allow",
      "Action": "secretsmanager:*",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "secretsmanager:ResourceTag/pod" : ["DE"]
        }
      }
    }
  ]
}
EOF
}

output "iam_policy_example_allow" {
  value = module.iam_policy_example_allow
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
| [terraform-aws-modules/iam-policy/aws.this](https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/5.32.0/examples/iam-policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | the name of the policy | `string` | `""` | yes |
| <a name="input_description"></a> [description](#input\_description) | A short description. | `string` | `""` | yes |
| <a name="input_policy"></a> [policy](#input\_policy) | string of json variables | `string` | `""` | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags | `map(string)` | `{}` | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | Policy Name |
| <a name="output_id"></a> [id](#output\_id) | Policy ID |
| <a name="output_description"></a> [description](#output\_description) | Policy description |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

