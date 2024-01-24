# github_team_membership

This resource allows you to add/remove users from teams in your organization. When applied, the user will be added to the team. If the user hasn't accepted their invitation to the organization, they won't be part of the team until they do. When destroyed, the user will be removed from the team.

## Usage Example


### Private Repository

```hcl
locals {
  dataengineering = toset([
    "AliceSmith485",
    "BobJohnson645",
    "CharlieWilliams834",
    "DavidJones857",
    "EveBrown756",
    "FrankDavis124",
  ])
}

module "team_dataengineering" {
  source           = "modules/github/v5/team_membership"
  team_name        = "dataengineering"
  team_description = "Data Engineering Team"
  team_member      = local.dataengineering
}

output "team_dataengineering" {
  value = module.team_dataengineering
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
| <a name="provider_github"></a> [github](#provider\_github) | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [terraform-aws-modules/github/repository.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_membership.html) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_team_name"></a> [team\_name](#input\_team\_name) | Name of github team name | `string` | `""` | yes |
| <a name="input_team_description"></a> [team\_description](#input\_team\_description) | Short description of the team | `string` | `""` | yes |
| <a name="input_team_member"></a> [team\_member](#input\_team\_member) | Add user/member to github team | `string` | `""` | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_team_name"></a> [team\_name](#output\_team\_name) | team info |
| <a name="output_team_id"></a> [team\_id](#output\_team\_id) | the team id |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

