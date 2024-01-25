data "aws_caller_identity" "production" {
  provider = aws.production
}

locals {
  repo_acc1 = "crytera"
}

################################################################################
# Create ECR image
# Example : xxxxxxx.dkr.ecr.us-east-1.amazonaws.com/crytera/xxxxxxxx
# Note : Removing a ecr repo will delete all images created under this repo too
################################################################################
locals {
  ecr_repo = {
    "repo01" = { acc_name = "${local.repo_acc1}", repo_name = "templateistio" },
    "repo02" = { acc_name = "${local.repo_acc1}", repo_name = "templatenginxistio" },
    "repo03" = { acc_name = "${local.repo_acc1}", repo_name = "templatefargate" },
    "repo04" = { acc_name = "${local.repo_acc1}", repo_name = "templateloadbalancer" },
    "repo05" = { acc_name = "${local.repo_acc1}", repo_name = "templaterollout" },
    "repo06" = { acc_name = "${local.repo_acc1}", repo_name = "templateapi" },
    "repo07" = { acc_name = "${local.repo_acc1}", repo_name = "nginx" },
    "repo08" = { acc_name = "${local.repo_acc1}", repo_name = "templatenginx" },
    "repo09" = { acc_name = "${local.repo_acc1}", repo_name = "templatephpfpm" },
    "repo10" = { acc_name = "${local.repo_acc1}", repo_name = "templatejs" },
  }
}

###########################################################################################
# Create ECR Module Repo(v1.6.0)
# ref : https://registry.terraform.io/modules/terraform-aws-modules/ecr/aws/1.6.0
###########################################################################################
module "ecr_template" {
  source         = "../../../../modules/aws/ecr/v1_6_0"
  for_each       = local.ecr_repo
  name           = "${each.value.acc_name}/${each.value.repo_name}"
  allow_readonly = ["arn:aws:iam::${data.aws_caller_identity.production.account_id}:root"]
  pod            = "DEVOPS"
  environment    = "staging"
}

# ECR Output info
output "ecr_template" {
  description = "ECR Output"
  value       = module.ecr_template
}
