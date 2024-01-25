###########################################################################################################
# ref : https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team
###########################################################################################################

locals {
  devops_team = [
    github_membership.simpleuser1.username,
    github_membership.membership_thinegan.username,
    github_membership.membership_atlantisbot_tmc.username,
  ]
}

# Imported
# terraform import github_team.team_devops 5233145
resource "github_team" "team_devops" {
  name        = "devops"
  description = "DevOps team"
  privacy     = "closed"
}

output "team_devops" {
  value = github_team.team_devops
}


resource "github_team_membership" "membership_devops" {
  team_id  = github_team.team_devops.id
  for_each = toset(sort(local.devops_team))
  username = each.value
}

resource "github_team_settings" "code_review_settings" {
  team_id = github_team.team_devops.id
  review_request_delegation {
    algorithm    = "ROUND_ROBIN"
    member_count = 1
    notify       = true
  }
}