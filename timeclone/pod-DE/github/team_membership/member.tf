###########################################################################################################
# ref : https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_members
# admin role represents the owner role
# Default is member role
# Add users/staff github username according to the relevant team.
###########################################################################################################

locals {

  dataengineering = toset([
    "AliceSmith",
    "BobJohnson",
    "CharlieWilliams",
    "DavidJones",
    "EveBrown",
    "FrankDavis"
  ])

  dataetl = toset([
    "BobJohnson",
    "CharlieWilliams",
    "GraceMiller"
  ])

  github_merged_team = setunion(local.dataengineering, local.dataetl)
}


# Enroll All users in the locals to the organization
resource "github_membership" "membership" {
  for_each = local.github_merged_team
  username = each.key
  role     = "member"
}

output "membership" {
  value = {
    for key, member in github_membership.membership :
    key => "member"
  }
}

