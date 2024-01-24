####################################################################################################################################################################
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository
# permission - (Optional) The permissions of team members regarding the repository. 
# Must be one of pull, triage, push, maintain, admin or the name of an existing custom repository role 
# within the organisation. Defaults to pull.
# Read: Recommended for non-code contributors who want to view or discuss your project
# Triage: Recommended for contributors who need to proactively manage issues, discussions, and pull requests without write access
# Write: Recommended for contributors who actively push to your project
# Maintain: Recommended for project managers who need to manage the repository without access to sensitive or destructive actions
# Admin: Recommended for people who need full access to the project, including sensitive and destructive actions like managing security or deleting a repository
####################################################################################################################################################################
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

output "repo_dataetl_script" {
  value = module.repo_dataetl_script
}
