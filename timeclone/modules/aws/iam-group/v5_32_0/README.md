# AWS IAM group with policies example

Configuration in this directory creates IAM group with users who has specified IAM policies.

## Usage Example

```hcl
module "group_dataengineer_advance" {
  source = "modules/aws/iam-group/v5_32_0"

  name = "DataEngineerAdvance"
  // Note: Cannot exceed quota for PoliciesPerGroup: 10
  group_policy_arns = [
    data.terraform_remote_state.devops_staging_iam.outputs.iam_policy_manageownmfa.id,
    "arn:aws:iam::aws:policy/AWSSupportAccess",
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonRDSPerformanceInsightsFullAccess",
    module.iam_policy_de_secretmanager_allow.id
  ]
}

output "group_dataengineer_advance" {
  value = module.group_dataengineer_advance
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
| [terraform-aws-modules/iam-group-with-policies/aws.this](https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/5.32.0/examples/iam-group-with-policies) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | the name of the group | `string` | `""` | yes |
| <a name="input_group_policy_arns"></a> [group_policy_arns](#input\_group\_policy\_arns) | The custom policy ARNs to be attached to the group | `list(string)` | `[]` | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_group_name"></a> [group_name](#output\_group\_name) | The group name |
| <a name="output_group_arn"></a> [group_arn](#output\_group\_arn) | The group arn |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

