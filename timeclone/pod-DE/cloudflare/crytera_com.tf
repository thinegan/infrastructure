#####################################################################################################
# Retrieve API token key and ZoneID from AWS Secret Manager
# Cloudflare API Access
#####################################################################################################

# Get Secret
data "aws_secretsmanager_secret_version" "get_cloudflare" {
  secret_id = data.terraform_remote_state.devops_staging_secretmanager.outputs.secrets_manager_cloudflare.id
}

provider "cloudflare" {
  api_token = jsondecode(data.aws_secretsmanager_secret_version.get_cloudflare.secret_string)["CLOUDFLARE_API_TOKEN"]
}

locals {
  zone_id = jsondecode(data.aws_secretsmanager_secret_version.get_cloudflare.secret_string)["CLOUDFLARE_ZONEID"]
  domain  = jsondecode(data.aws_secretsmanager_secret_version.get_cloudflare.secret_string)["CLOUDFLARE_DOMAIN"]
}

#####################################################################################################
# Step 1  : Pre-setup sub domain/hostname for crytera.com
# Example : tester1.crytera.com / dashboard.crytera.com
# ref : https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record
#####################################################################################################
# tester1.crytera.com
# resource "cloudflare_record" "crytera_tester1" {
#   zone_id = local.zone_id
#   name    = "tester1"
#   value   = "1.1.1.1"
#   type    = "A"
# }

# dashboard.crytera.com
# resource "cloudflare_record" "crytera_dashboard" {
#   zone_id = local.zone_id
#   name    = "dashboard"
#   value   = "1.1.1.1"
#   type    = "A"
# }
