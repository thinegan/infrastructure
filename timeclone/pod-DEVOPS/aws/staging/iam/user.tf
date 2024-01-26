# ###########################################################################################
# # Import existing user :
# # In Terraform v1.5.0 and later, use an import block to import IAM Users using the name.
# ###########################################################################################
# import {
#   to = aws_iam_user.terraformer
#   id = "terraformer"
# }

# # terraform import aws_iam_user.terraformer terraformer

# resource "aws_iam_user" "terraformer" {
#   name = "terraformer"
#   path = "/"

#   tags = {
#     pod = "atlantis-terraform"
#   }
# }

#########################################
# IAM user, login profile and access key
#########################################
module "iam_user_rthinegan" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-user"
  version                       = "5.10.0"
  name                          = "rthinegan"
  force_destroy                 = true
  create_iam_user_login_profile = true
  create_iam_access_key         = true
  password_reset_required       = true

  tags = {
    pod = "DEVOPS"
  }
}

output "iam_user_rthinegan" {
  value     = module.iam_user_rthinegan
  sensitive = true
}

#########################################
# IAM user, login profile and access key
#########################################
module "iam_user_thinegan" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "5.10.0"

  name                          = "thinegan"
  force_destroy                 = true
  create_iam_user_login_profile = true
  create_iam_access_key         = true
  password_reset_required       = true

  tags = {
    pod = "DEVOPS"
  }
}

output "iam_user_thinegan" {
  value     = module.iam_user_thinegan
  sensitive = true
}
