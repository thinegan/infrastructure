data "terraform_remote_state" "devops_staging_secretmanager" {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "terraform-stag-state-storage"
    dynamodb_table = "stag-terraform-state-table"
    region         = "us-east-1"
    key            = "timeclone/pod-DEVOPS/aws/staging/secretmanager/terraform.tfstate"
  }
}

#########################################################################################################
# Retrieve Mailersend API token key and Other Credentials from AWS Secret Manager
#########################################################################################################
data "aws_secretsmanager_secret_version" "get_mailersend" {
  secret_id = data.terraform_remote_state.devops_staging_secretmanager.outputs.secrets_manager_mailersend.id
}

locals {
  mailersend_token        = jsondecode(data.aws_secretsmanager_secret_version.get_mailersend.secret_string)["TOKEN"]
  mailersend_email_sender = jsondecode(data.aws_secretsmanager_secret_version.get_mailersend.secret_string)["EMAIL_SENDER"]
  mailersend_account      = jsondecode(data.aws_secretsmanager_secret_version.get_mailersend.secret_string)["ACCOUNT_NAME"]
  mailersend_templateid   = jsondecode(data.aws_secretsmanager_secret_version.get_mailersend.secret_string)["TEMPLATEID"]
  pgp_usr_publickey       = jsondecode(data.aws_secretsmanager_secret_version.get_mailersend.secret_string)["PGP_KEY_USR"]
  # passreset = sum([12, ])
}

###################################################################################################
## ref : https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/5.32.0
###################################################################################################

module "this" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "5.32.0"

  name        = var.username
  tags        = merge(var.tags, { full-name = var.fullname })
  policy_arns = var.policy_arns

  force_destroy                 = true
  create_iam_user_login_profile  = true
  create_iam_access_key         = false
  password_reset_required       = true

  # User "<username>" has uploaded public key here - https://keybase.io/<username>/pgp_keys.asc
  pgp_key = local.pgp_usr_publickey
  password_length = sum([12, var.forcedreset])

}

resource "aws_iam_user_group_membership" "this" {
  user   = var.username
  groups = var.groups

  depends_on = [
    module.this,
  ]
}

resource "null_resource" "this" {

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]

    # Note: this requires the awscli to be installed locally where Terraform is executed
    command = <<-EOT
curl -X POST \
https://api.mailersend.com/v1/email \
-H 'Content-Type: application/json' \
-H 'X-Requested-With: XMLHttpRequest' \
-H 'Authorization: Bearer ${local.mailersend_token}' \
-d '{
    "from": {
        "email": "${local.mailersend_email_sender}"
    },
    "to": [
        {
            "email": "${var.email}"
        }
    ],
    "personalization": [{
        "email": "${var.email}",
        "data": {
            "username": "${var.username}",
            "account_name": "${local.mailersend_account}",
            "group": "${join(",", var.groups)}",
            "fullname": "${var.fullname}"
        }
    }],
    "template_id": "${local.mailersend_templateid}"
}'
EOT
  }

  depends_on = [
    aws_iam_user_group_membership.this,
  ]
}
