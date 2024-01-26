
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

locals {
  user = "terraformer"
}

###################################################################################################
## ref : https://registry.terraform.io/modules/terraform-aws-modules/kms/aws/2.1.0
###################################################################################################

module "kms_timeclone_dev" {
  source  = "terraform-aws-modules/kms/aws"
  version = "2.1.0"

  description         = "External key example"
  key_usage           = "ENCRYPT_DECRYPT"
  enable_key_rotation = false

  # Policy
  key_owners = [data.terraform_remote_state.devops_staging_iam.outputs.iam_user_rthinegan.iam_user_arn]
  key_administrators = [
    data.terraform_remote_state.devops_staging_iam.outputs.iam_user_thinegan.iam_user_arn,
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${local.user}"
  ]

  key_users = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${local.user}"
  ]

  key_service_roles_for_autoscaling = [
    # required for the ASG to manage encrypted volumes for eks nodes
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
  ]

  # Aliases
  aliases                 = ["timeclone-dev/external"]
  aliases_use_name_prefix = true

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}

output "kms_timeclone_dev" {
  value     = module.kms_timeclone_dev
  sensitive = true
}
