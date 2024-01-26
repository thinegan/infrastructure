####################################################################################################################################
# ref: https://docs.snyk.io/integrate-with-snyk/snyk-container-integrations/container-security-with-amazon-elastic-container-registry-ecr-integrate-and-test/configure-integration-for-amazon-elastic-container-registry-ecr
####################################################################################################################################
resource "aws_iam_role" "synk_ecr_role" {
  name = "SnykServiceECR"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : "arn:aws:iam::198361731867:user/ecr-integration-user"
          },
          "Action" : "sts:AssumeRole",
          "Condition" : {
            "StringEquals" : {
              "sts:ExternalId" : "68cc36a1-f63e-4b42-ac73-3e68dc5ae1f9"
            }
          }
        }
      ]
  })

  managed_policy_arns = [
    module.iam_staging_ecr_synk_crytera_terraform.arn
  ]

  tags = {
    owner = "3rd-party"
  }
}

####################################################################################################################################
# IAM Custom policy
# Allow Synk ECR Scan = synk-crytera-terraform-tfstate
####################################################################################################################################
module "iam_staging_ecr_synk_crytera_terraform" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.10.0"

  name        = "AmazonEC2ContainerRegistryReadOnlyForSnyk2"
  path        = "/"
  description = "Synk access to ecr images crytera"

  policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
  {
   "Sid": "SnykAllowPull",
   "Effect": "Allow",
   "Action": [
    "ecr:GetLifecyclePolicyPreview",
    "ecr:GetDownloadUrlForLayer",
    "ecr:BatchGetImage",
    "ecr:DescribeImages",
    "ecr:GetAuthorizationToken",
    "ecr:DescribeRepositories",
    "ecr:ListTagsForResource",
    "ecr:ListImages",
    "ecr:BatchCheckLayerAvailability",
    "ecr:GetRepositoryPolicy",
    "ecr:GetLifecyclePolicy"
   ],
   "Resource": "*"
  }
 ]
}
EOF

  tags = {
    PolicyDescription = "Custom Policy created to access ecr images terraform"
    owner             = "3rd-party"
  }
}

output "ecr_synk_crytera_terraform_arn" {
  description = "The ARN of the policy."
  value       = module.iam_staging_ecr_synk_crytera_terraform.arn
}
