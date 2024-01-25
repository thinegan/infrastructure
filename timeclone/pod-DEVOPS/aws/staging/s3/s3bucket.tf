# ###################################################################################################
# ## ref : https://github.com/terraform-aws-modules
# ## ref : https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/latest
# ###################################################################################################

# Create S3 from Modules
module "s3_github_terraform" {
  source = "../../../../modules/aws/s3/v3_15_1"

  name        = "github-crytera-terraform-tfstate"
  pod         = "DEVOPS"
  environment = "staging"
}

output "s3_github_terraform" {
  description = "The name of the bucket."
  value       = module.s3_github_terraform
}
