
module "iam_user" {
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