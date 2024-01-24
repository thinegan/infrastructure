###########################################################################################################
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret
###########################################################################################################

locals {
  prefix = "de" //Data Engineering
  kmsid  = data.terraform_remote_state.devops_staging_kms.outputs.kms_timeclone_dev.key_arn
  tags = {
    Pod         = "DE"
    Environment = "staging"
    Terraform   = "true"
  }

  prefix_common = "common" //Common - Allow Read Access to All users
  tags_common = {
    Pod         = "ALL"
    Environment = "staging"
    Terraform   = "true"
  }
}

##################################################################################################
# Create Secret - airflow
module "secrets_manager_airflow" {
  source      = "../../../../modules/aws/secretmanager/v1_1_1"
  name        = "${local.prefix}-airflow"
  tags        = local.tags
  kms_key_id  = local.kmsid
  description = "airflow token access for control user"
}

output "secrets_manager_airflow" {
  value = module.secrets_manager_airflow
}
