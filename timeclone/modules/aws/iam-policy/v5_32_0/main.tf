###################################################################################################
## ref : https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/5.32.0
###################################################################################################

module "this" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.32.0"

  name        = var.name
  path        = "/"
  description = var.description
  policy      = var.policy
  tags        = var.tags
}
