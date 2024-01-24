##################################################################################################
# Secret Manager Module
# ref: https://registry.terraform.io/modules/terraform-aws-modules/secrets-manager/aws/1.1.1
##################################################################################################

module "this" {
  source  = "terraform-aws-modules/secrets-manager/aws"
  version = "1.1.1"

  # Secret
  name                    = var.name
  description             = var.description
  tags                    = var.tags
  kms_key_id              = var.kms_key_id
  recovery_window_in_days = 0

  # Version
  ignore_secret_changes = true
  secret_string         = jsonencode({})
}
