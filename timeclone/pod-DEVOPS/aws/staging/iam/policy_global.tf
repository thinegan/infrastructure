
locals {
  tags = {
    Pod         = "DEVOPS"
    Environment = "staging"
    Terraform   = "true"
  }
}

####################################################################################################################################
# IAM Global policy
# Set Password Compliance Policy
####################################################################################################################################
module "iam_password_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-account"
  version = "5.32.0"

  account_alias                  = "timeclone-dev"
  minimum_password_length        = 12
  password_reuse_prevention      = 2
  max_password_age               = 90
  allow_users_to_change_password = true
  require_lowercase_characters   = true
  require_uppercase_characters   = true
  require_numbers                = true
  require_symbols                = false

}

####################################################################################################################################
# IAM Global policy
# Ref : https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_examples_aws_my-sec-creds-self-manage-mfa-only.html
####################################################################################################################################

module "iam_policy_manageownmfa" {
  source = "../../../../modules/aws/iam-policy/v5_32_0"

  name        = "ManageOwnMFA"
  description = "Allows MFA-authenticated IAM users to manage their own MFA device on the My Security Credentials page"
  tags        = local.tags
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "iam:GetAccountPasswordPolicy",
        "iam:GetAccountSummary",
        "iam:ListVirtualMFADevices"
      ],
      "Resource": "*",
      "Effect": "Allow",
      "Sid": "AllowViewAccountInfo"
    },
    {
      "Action": [
        "iam:ChangePassword",
        "iam:GetUser"
      ],
      "Resource": "arn:aws:iam::*:user/$${aws:username}",
      "Effect": "Allow",
      "Sid": "AllowManageOwnPasswords"
    },
    {
      "Action": [
        "iam:CreateAccessKey",
        "iam:DeleteAccessKey",
        "iam:ListAccessKeys",
        "iam:UpdateAccessKey"
      ],
      "Resource": "arn:aws:iam::*:user/$${aws:username}",
      "Effect": "Allow",
      "Sid": "AllowManageOwnAccessKeys"
    },
    {
      "Action": [
        "iam:DeleteSigningCertificate",
        "iam:ListSigningCertificates",
        "iam:UpdateSigningCertificate",
        "iam:UploadSigningCertificate"
      ],
      "Resource": "arn:aws:iam::*:user/$${aws:username}",
      "Effect": "Allow",
      "Sid": "AllowManageOwnSigningCertificates"
    },
    {
      "Action": [
        "iam:DeleteSSHPublicKey",
        "iam:GetSSHPublicKey",
        "iam:ListSSHPublicKeys",
        "iam:UpdateSSHPublicKey",
        "iam:UploadSSHPublicKey"
      ],
      "Resource": "arn:aws:iam::*:user/$${aws:username}",
      "Effect": "Allow",
      "Sid": "AllowManageOwnSSHPublicKeys"
    },
    {
      "Action": [
        "iam:CreateServiceSpecificCredential",
        "iam:DeleteServiceSpecificCredential",
        "iam:ListServiceSpecificCredentials",
        "iam:ResetServiceSpecificCredential",
        "iam:UpdateServiceSpecificCredential"
      ],
      "Resource": "arn:aws:iam::*:user/$${aws:username}",
      "Effect": "Allow",
      "Sid": "AllowManageOwnGitCredentials"
    },
    {
      "Action": [
        "iam:CreateVirtualMFADevice",
        "iam:DeleteVirtualMFADevice"
      ],
      "Resource": "arn:aws:iam::*:mfa/*",
      "Effect": "Allow",
      "Sid": "AllowManageOwnVirtualMFADevice"
    },
    {
      "Action": [
        "iam:DeactivateMFADevice",
        "iam:EnableMFADevice",
        "iam:ListMFADevices",
        "iam:ResyncMFADevice"
      ],
      "Resource": "arn:aws:iam::*:user/$${aws:username}",
      "Effect": "Allow",
      "Sid": "AllowManageOwnUserMFA"
    },
    {
      "Condition": {
        "BoolIfExists": {
          "aws:MultiFactorAuthPresent": "false"
        }
      },
      "Resource": "*",
      "Effect": "Deny",
      "NotAction": [
        "iam:CreateVirtualMFADevice",
        "iam:EnableMFADevice",
        "iam:GetUser",
        "iam:ListMFADevices",
        "iam:ListVirtualMFADevices",
        "iam:ResyncMFADevice",
        "iam:ChangePassword",
        "iam:GetUser",
        "sts:GetSessionToken"
      ],
      "Sid": "DenyAllExceptListedIfNoMFA"
    }
  ]
}
EOF
}

output "iam_policy_manageownmfa" {
  value = module.iam_policy_manageownmfa
}
