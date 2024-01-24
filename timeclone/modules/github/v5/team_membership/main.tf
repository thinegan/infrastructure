data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

###################################################################################################################
## ref : https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_membership.html
###################################################################################################################

resource "github_team" "this" {
  name        = var.team_name
  description = var.team_description
  privacy     = "closed"
}

resource "github_team_settings" "this" {
  team_id = github_team.this.id
  review_request_delegation {
    algorithm    = "ROUND_ROBIN"
    member_count = 1
    notify       = true
  }
}

resource "github_team_membership" "this" {
  for_each = { for v in var.team_member : v => v }
  team_id  = github_team.this.id
  username = each.key
  # Default role is member
}
