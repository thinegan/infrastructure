#####################################################################################################################
# ref : https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/5.32.0
# ref : https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/5.32.0/examples/iam-group-with-policies
#####################################################################################################################

module "this" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "5.32.0"

  name                              = var.name
  attach_iam_self_management_policy = false
  custom_group_policy_arns          = var.group_policy_arns
}

