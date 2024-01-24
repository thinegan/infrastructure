# github_repository

This resource allows you to create and manage repositories within your GitHub organization or personal account.

## Usage Example


### Private Repository

```hcl
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository
# permission - (Optional) The permissions of team members regarding the repository. 
# Must be one of pull, triage, push, maintain, admin or the name of an existing custom repository role 
# within the organisation. Defaults to pull.
# Read: Recommended for non-code contributors who want to view or discuss your project
# Triage: Recommended for contributors who need to proactively manage issues, discussions, and pull requests without write access
# Write: Recommended for contributors who actively push to your project
# Maintain: Recommended for project managers who need to manage the repository without access to sensitive or destructive actions
# Admin: Recommended for people who need full access to the project, including sensitive and destructive actions like managing security or deleting a repository

module "repo_dataetl_script" {
  source           = "modules/github/v5/repository"
  repo_name        = "ETL-Script"
  repo_description = "ETL script tools"
  repo_team_owner = [
    {
      id         = data.terraform_remote_state.de_staging_team_membership.outputs.team_dataetl.team_id
      permission = "push"
    },
    {
      id         = data.terraform_remote_state.de_staging_team_membership.outputs.team_dataengineering.team_id
      permission = "push"
    }
  ]
}

output "repo_dataetl_script" {
  value = module.repo_dataetl_script
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
| [terraform-aws-modules/github/repository.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | Repository name | `string` | `""` | yes |
| <a name="input_repo_description"></a> [repo\_description](#input\_repo\_description) | Repository description | `string` | `""` | yes |
| <a name="input_repo_visibility"></a> [repo\_visibility](#input\_repo\_visibility) | Visibility of the repo private/public | `string` | `""` | no |
| <a name="input_repo_team_permission"></a> [repo\_team\_permission](#input\_repo\_team\_permission) | Team permission to repo | `string` | `""` | no |
| <a name="input_repo_team_owner"></a> [repo\_team\_owner](#input\_repo\_team\_owner) | Team Owner id to repo | `list(object)` | `[]` | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | Repository name |
| <a name="output_visibility"></a> [visibility](#output\_visibility) | Repository visibility |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

