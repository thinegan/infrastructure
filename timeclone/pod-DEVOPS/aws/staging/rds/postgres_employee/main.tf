// AWS Provider
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform-stag-state-storage"
    key            = "timeclone/pod-DEVOPS/aws/staging/rds/postgres_employee/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "stag-terraform-state-table"
  }
}

data "terraform_remote_state" "devops_staging_network" {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "terraform-stag-state-storage"
    dynamodb_table = "stag-terraform-state-table"
    region         = "us-east-1"
    key            = "timeclone/pod-DEVOPS/aws/staging/network/terraform.tfstate"
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
# Retrieve Postgres Credential from AWS Secret Manager
#####################################################################################################

# Get Secret
data "aws_secretsmanager_secret_version" "get_rds" {
  secret_id = data.terraform_remote_state.devops_staging_secretmanager.outputs.secrets_manager_rds_postgres_employee.id
}

locals {
  jdbc_username = jsondecode(data.aws_secretsmanager_secret_version.get_rds.secret_string)["JDBC_USERNAME"]
  jdbc_password = jsondecode(data.aws_secretsmanager_secret_version.get_rds.secret_string)["JDBC_PASSWORD"]
}

#####################################################################################################
# Retrieve API token key and ZoneID from AWS Secret Manager
# Cloudflare API Access
#####################################################################################################

# Get Secret
data "aws_secretsmanager_secret_version" "get_cloudflare" {
  secret_id = data.terraform_remote_state.devops_staging_secretmanager.outputs.secrets_manager_cloudflare.id
}

provider "cloudflare" {
  api_token = jsondecode(data.aws_secretsmanager_secret_version.get_cloudflare.secret_string)["CLOUDFLARE_API_TOKEN"]
}

locals {
  zone_id = jsondecode(data.aws_secretsmanager_secret_version.get_cloudflare.secret_string)["CLOUDFLARE_ZONEID"]
  domain  = jsondecode(data.aws_secretsmanager_secret_version.get_cloudflare.secret_string)["CLOUDFLARE_DOMAIN"]
}
