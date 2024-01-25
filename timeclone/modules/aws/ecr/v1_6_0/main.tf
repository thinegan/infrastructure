data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

locals {
  # user that have access in the CICD platform to build and upload to ECR repo
  user = "terraformer"
}

###################################################################################################
## ref : https://registry.terraform.io/modules/terraform-aws-modules/ecr/aws/1.6.0
###################################################################################################
module "this" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "1.6.0"

  repository_name                   = var.name
  repository_force_delete           = true
  repository_read_write_access_arns = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${local.user}"]
  repository_read_access_arns       = var.allow_readonly
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 10 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 10
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    Terraform   = "true"
    Environment = var.environment
    pod         = var.pod
  }
}
