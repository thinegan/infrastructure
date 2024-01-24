####################################################################################################################################
# IAM Custom policy
# Allow DE Team to Read/Write Secret Manager that only under Tag Resource 'pod=DE/COMMON'
####################################################################################################################################
module "iam_policy_de_secretmanager_allow" {
  source = "../../../../modules/aws/iam-policy/v5_32_0"

  name        = "${local.prefix}-secretmanager-allow"
  description = "Allow DE Team to Manage Secret Manager"
  tags        = local.tags
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowReadWriteDE",
      "Effect": "Allow",
      "Action": "secretsmanager:*",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "secretsmanager:ResourceTag/pod" : ["DE"]
        }
      }
    },
    {
      "Sid": "AllowReadOnlyDE",
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetResourcePolicy",
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret",
        "secretsmanager:ListSecretVersionIds"              
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "secretsmanager:ResourceTag/pod" : ["ALL"]
        }
      }
    },
    {
      "Sid": "AllowCustomKMS",
      "Effect": "Allow",
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowListing",
      "Effect": "Allow",
      "Action": ["secretsmanager:ListSecrets"],
      "Resource": "*"
    }
  ]
}
EOF
}

output "iam_policy_de_secretmanager_allow" {
  value = module.iam_policy_de_secretmanager_allow
}

####################################################################################################################################
# IAM Custom policy
# ReadOnly s3 bucket = timeclone staging
####################################################################################################################################
module "iam_staging_s3_readonly_timeclone_dev1" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.30.0"

  name        = "staging-s3-readonly-timeclone-dev1"
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