###########################################################################################
# Create Github Team Module for every new team created in locals
# ref : https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team
###########################################################################################
module "team_dataetl" {
  source           = "../../../modules/github/v5/team_membership"
  team_name        = "dataetl"
  team_description = "Extract, transform, load Team"
  team_member      = local.dataetl
}

output "team_dataetl" {
  value = module.team_dataetl
}


module "team_dataengineering" {
  source           = "../../../modules/github/v5/team_membership"
  team_name        = "dataengineering"
  team_description = "Data Engineering Team"
  team_member      = local.dataengineering
}

output "team_dataengineering" {
  value = module.team_dataengineering
}

