# Github membership
This reference architecture provides for deploying the following services :
- Github Membership

## Prerequisites Notes
Ref : https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_members

- admin role represents the owner role
- Default is member role
- Add users/staff github username according to the relevant team

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
locals { 
  devops_team = [
    github_membership.simpleuser1.username,
    github_membership.membership_thinegan.username,
    github_membership.membership_atlantisbot_tmc.username,
  ]
}

resource "github_team" "team_devops" {
  name        = "devops"
  description = "DevOps team"
  privacy     = "closed"
}

resource "github_team_membership" "membership_devops" {
  team_id  = github_team.team_devops.id
  for_each = toset(sort(local.devops_team))
  username = each.value
}
```

## Author

Thinegan Ratnam
 - [http://thinegan.com](http://thinegan.com/)

## Copyright and License

Copyright 2024 Thinegan Ratnam

Code released under the MIT License.