###########################################################################################################
# ref : https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_members
###########################################################################################################

# Add a user to the organization
resource "github_membership" "simpleuser1" {
  username = "simpleuser1"
  role     = "member"
}

# Imported
resource "github_membership" "membership_thinegan" {
  username = "thinegan"
  role     = "member"
}

# Imported
resource "github_membership" "membership_atlantisbot_tmc" {
  username = "atlantisbot-tmc"
  role     = "admin"
}
