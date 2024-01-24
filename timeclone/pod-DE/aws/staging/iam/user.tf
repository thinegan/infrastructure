#########################################
# IAM user, login profile and access key
#########################################
module "user_BobJohnson" {
  source = "../../../../modules/aws/iam-user/v5_32_0"

  username = "BobJohnson"
  fullname = "Bob Johnson"
  email    = "BobJohnson@crytera.com"
  tags     = local.tags

  // Attach with all relevant group(s)
  groups = [
    module.group_dataengineer_advance.group_name
  ]

  // Custom policy dedicated for this user only
  policy_arns = [
    module.iam_staging_s3_readonly_timeclone_dev1.arn
  ]
}

# ECR Output info
output "user_BobJohnson" {
  value = module.user_BobJohnson
}


#########################################
# IAM user, login profile and access key
#########################################
module "user_EveBrown" {
  source = "../../../../modules/aws/iam-user/v5_32_0"

  username = "EveBrown"
  fullname = "Eve Brown"
  email    = "EveBrown@crytera.com"
  tags     = local.tags

  // Attach with all relevant group(s)
  groups = [
    module.group_dataengineer_advance.group_name,
    module.group_dataengineer_novice.group_name
  ]

  // Custom policy dedicated for this user only
  policy_arns = [
    module.iam_staging_s3_readonly_timeclone_dev1.arn
  ]
}

# ECR Output info
output "user_EveBrown" {
  value = module.user_EveBrown
}
