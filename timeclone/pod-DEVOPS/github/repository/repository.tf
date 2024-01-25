###########################################################################################################
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository
###########################################################################################################

resource "github_repository" "repo_myterra1" {
  name        = "myterra1"
  description = "Simple terraform testing repo"
  visibility  = "private"
}

resource "github_team_repository" "team_devops_myterra1" {
  team_id    = data.terraform_remote_state.devops_staging_team_membership.outputs.team_devops.id
  repository = github_repository.repo_myterra1.name
  permission = "admin"
}

resource "github_repository" "repo_terrademo1" {
  name        = "terrademo1"
  description = "Simple terraform testing repo"
  visibility  = "private"
}

resource "github_team_repository" "team_devops_terrademo1" {
  team_id    = data.terraform_remote_state.devops_staging_team_membership.outputs.team_devops.id
  repository = github_repository.repo_terrademo1.name
  permission = "admin"
}

resource "github_repository" "repo_templateapi" {
  name        = "templateapi"
  description = "Simple templateapi java testing repo"
  visibility  = "private"
}

resource "github_team_repository" "team_devops_templateapi" {
  team_id    = data.terraform_remote_state.devops_staging_team_membership.outputs.team_devops.id
  repository = github_repository.repo_templateapi.name
  permission = "admin"
}
