
module "iam_group_devops_advance" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "5.10.0"

  name                              = "DevOpsAdvance"
  attach_iam_self_management_policy = false

  group_users = [
    module.iam_user_rthinegan.iam_user_name,
  ]

  custom_group_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
    "arn:aws:iam::aws:policy/job-function/Billing",
    module.iam_production_crossaccountadminrole.id,
  ]
}


module "iam_group_devops_novice" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "5.10.0"

  name                              = "DevOpsNovice"
  attach_iam_self_management_policy = false

  group_users = [
    module.iam_user_thinegan.iam_user_name,
  ]

  custom_group_policy_arns = [
    module.iam_staging_s3_readonly_timeclone_dev.id,
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
  ]
}

