// AWS Provider
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform-stag-state-storage"
    key            = "timeclone/pod-DE/github/team_membership/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "stag-terraform-state-table"
  }
}

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

#####################################################################################################
# Retrieve API token key from AWS Secret Manager
# Github API Access
#####################################################################################################

# Get Secret
data "aws_secretsmanager_secret_version" "get_github" {
  secret_id = data.terraform_remote_state.devops_staging_secretmanager.outputs.secrets_manager_github_crytera.id
}

provider "github" {
  token = jsondecode(data.aws_secretsmanager_secret_version.get_github.secret_string)["GITHUB_TOKEN"]
  owner = jsondecode(data.aws_secretsmanager_secret_version.get_github.secret_string)["GITHUB_OWNER"]
}