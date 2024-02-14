# Github Repository
This reference architecture provides for deploying the following services :
- Github Repository

## Prerequisites Notes
Ref : https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository

Ref: https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_repository

permission - (Optional) The permissions of team members regarding the repository. Must be one of pull, triage, push, maintain, admin or the name of an existing custom repository role within the organisation. Defaults to pull.
- pull: Recommended for non-code contributors who want to view or discuss your project
- triage: Recommended for contributors who need to proactively manage issues, discussions, and pull requests without write access
- push: Recommended for contributors who actively push to your project
- maintain: Recommended for project managers who need to manage the repository without access to sensitive or destructive actions
- admin: Recommended for people who need full access to the project, including sensitive and destructive actions like managing security or deleting a repository


### Tested on the following Region:
 - US East (N. Virginia)

## Quickstart
Make sure awscli is configured using `aws configure`, or the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` are properly exported into the environment.

Run Terraform Install Secret Manager:

```bash
terraform init
terraform plan -out=plan.tfplan
terraform apply "plan.tfplan"
```

Run Terraform Uninstall Secret manager:

```bash
terraform destroy -auto-approve
```

### Example Setup

```hcl
module "repo_dataetl_script" {
  source           = "../../../modules/github/v5/repository"
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
```

## Author

Thinegan Ratnam
 - [http://thinegan.com](http://thinegan.com/)

## Copyright and License

Copyright 2024 Thinegan Ratnam

Code released under the MIT License.