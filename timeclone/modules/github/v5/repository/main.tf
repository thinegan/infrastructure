###################################################################################################################
## ref : https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository
## ref : https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_repository
###################################################################################################################

resource "github_repository" "this" {
  name        = var.repo_name
  description = var.repo_description
  visibility  = var.repo_visibility
}

resource "github_team_repository" "this" {
  for_each   = { for idx, owner in var.repo_team_owner : idx => owner }
  team_id    = each.value.id
  permission = each.value.permission
  repository = github_repository.this.name
}
