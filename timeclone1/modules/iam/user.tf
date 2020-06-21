
module "iam_user_ratnam" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "~> 2.0"

  name          = "ratnam"
  force_destroy = true
  
  pgp_key = "keybase:thinegan"
  password_reset_required = false

  tags = {
    pod = "Devops"
  }
}

output "iam_user_ratnam" {
  value = module.iam_user_ratnam
}

