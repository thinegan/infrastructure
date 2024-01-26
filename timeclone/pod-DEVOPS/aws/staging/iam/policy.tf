data "aws_caller_identity" "production" {
  provider = aws.production
}

####################################################################################################################################
# IAM Custom policy
# ReadOnly s3 bucket = timeclonelab
####################################################################################################################################
module "iam_staging_s3_readonly_timeclone_dev" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.10.0"

  name        = "staging-s3-readonly-timeclone-dev"
  path        = "/"
  description = "ReadOnly Access to s3 bucket timeclone staging"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": "s3:ListAllMyBuckets",
            "Resource": "*"
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucketVersions",
                "s3:ListBucket",
                "s3:GetBucketVersioning"
            ],
            "Resource": "arn:aws:s3:::timeclone-dev"
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "s3:GetObjectVersionTorrent",
                "s3:GetObjectVersionTagging",
                "s3:GetObjectVersionForReplication",
                "s3:GetObjectVersionAcl",
                "s3:GetObjectVersion",
                "s3:GetObjectTorrent",
                "s3:GetObjectTagging",
                "s3:GetObjectRetention",
                "s3:GetObjectLegalHold",
                "s3:GetObjectAcl",
                "s3:GetObject"
            ],
            "Resource": "arn:aws:s3:::timeclone-dev/*"
        }
    ]
}
EOF

  tags = {
    PolicyDescription = "Custom Policy created readonly s3 bucket timeclone staging"
  }
}

####################################################################################################################################
# IAM Custom policy
# Access s3 bucket = github-crytera-terraform-tfstate
####################################################################################################################################
module "iam_staging_s3_github_crytera_terraform" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.10.0"

  name        = "staging-github-crytera-terraform"
  path        = "/"
  description = "Access to s3 bucket github crytera"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "s3:PutObject",
              "s3:GetObject",
              "s3:ListBucket"
          ],
          "Resource": [
              "arn:aws:s3:::github-crytera-terraform-tfstate/*",
              "arn:aws:s3:::github-crytera-terraform-tfstate"
          ]
      }
  ]
}
EOF

  tags = {
    PolicyDescription = "Custom Policy created to access s3 bucket github terraform"
  }
}

output "s3_github_crytera_terraform_arn" {
  description = "The ARN of the policy."
  value       = module.iam_staging_s3_github_crytera_terraform.arn
}

####################################################################################################################################
# IAM Custom policy
# Production_CrossAccountAdminRole
####################################################################################################################################
module "iam_production_crossaccountadminrole" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.10.0"

  name        = "ProductionCrossAccountAdminRole"
  path        = "/"
  description = "Assume role to access production aws account"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "arn:aws:iam::${data.aws_caller_identity.production.account_id}:role/CrossAccountAdmin"
        }
    ]
}
EOF

  tags = {
    PolicyDescription = "Custom Policy created to access production aws account"
  }
}

output "production_crossaccountadminrole_arn" {
  description = "The ARN of the policy."
  value       = module.iam_production_crossaccountadminrole.arn
}
