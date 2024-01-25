locals {
  prefix = "devops" //DevOps
  kmsid  = data.terraform_remote_state.devops_staging_kms.outputs.kms_timeclone_dev.key_arn
  tags = {
    Pod         = "DEVOPS"
    Environment = "staging"
    Terraform   = "true"
  }

  prefix_common = "common" //Common - Allow Read Access to All users
  tags_common = {
    Pod         = "ALL"
    Environment = "staging"
    Terraform   = "true"
  }
}

################################################################################################################################
# ref: https://stackoverflow.com/questions/55202810/retrieving-multiple-aws-secrets-manager-in-1-call
# not recommend combining multiple key credential, however, unless these secrets are strongly related. For example, a set of 
# secrets needed by a single application. Even then, you should avoid this if possible. Combining secrets 
# causes problems if you try to automate rotation, and becomes a problem when you need to split up an application 
# and the permissions/secrets that go along with them.

# Example force deletion:
# aws secretsmanager delete-secret --secret-id devops-secret-xxxxxx --force-delete-without-recovery --region us-east-1
################################################################################################################################

# Create Secret - Cloudflare
module "secrets_manager_cloudflare" {
  source      = "../../../../modules/aws/secretmanager/v1_1_1"
  name        = "${local.prefix}-cloudflare"
  tags        = local.tags
  kms_key_id  = local.kmsid
  description = "Cloudflare API token, email and domain zoneid"
}

output "secrets_manager_cloudflare" {
  value = module.secrets_manager_cloudflare
}

##################################################################################################
# Create Secret - AWS Keypair - us-east-1
module "secrets_manager_keypair_us_east_1" {
  source      = "../../../../modules/aws/secretmanager/v1_1_1"
  name        = "${local.prefix}-keypair-use-east-1"
  tags        = local.tags
  kms_key_id  = local.kmsid
  description = "Keypair for ec2 instance access"
}

output "secrets_manager_keypair_us_east_1" {
  value = module.secrets_manager_keypair_us_east_1
}

##################################################################################################
# Create Secret - Github token - Manage Github - Organisation
module "secrets_manager_github_crytera" {
  source      = "../../../../modules/aws/secretmanager/v1_1_1"
  name        = "${local.prefix}-github-crytera"
  tags        = local.tags
  kms_key_id  = local.kmsid
  description = "Github token to manage github"
}

output "secrets_manager_github_crytera" {
  value = module.secrets_manager_github_crytera
}

##################################################################################################
# Create Secret - Github token - ArgoCD Dex
module "secrets_manager_github_argocd" {
  source      = "../../../../modules/aws/secretmanager/v1_1_1"
  name        = "${local.prefix}-github-argocd"
  tags        = local.tags
  kms_key_id  = local.kmsid
  description = "Github token to manage argocd dex.config"
}

output "secrets_manager_github_argocd" {
  value = module.secrets_manager_github_argocd
}

##################################################################################################
# Create Secret - Github token - atlantisbot
module "secrets_manager_github_atlantisbot" {
  source      = "../../../../modules/aws/secretmanager/v1_1_1"
  name        = "${local.prefix}-github-atlantisbot"
  tags        = local.tags
  kms_key_id  = local.kmsid
  description = "Github token for atlantisbot user"
}

output "secrets_manager_github_atlantisbot" {
  value = module.secrets_manager_github_atlantisbot
}

##################################################################################################
# Create Secret - Datadog License - control (All Users)
module "secrets_manager_datadog" {
  source      = "../../../../modules/aws/secretmanager/v1_1_1"
  name        = "${local.prefix_common}-datadog"
  tags        = local.tags_common
  kms_key_id  = local.kmsid
  description = "Datadog license for control user"
}

output "secrets_manager_datadog" {
  value = module.secrets_manager_datadog
}

##################################################################################################
# Create Secret - twingate License - control
module "secrets_manager_twingate" {
  source      = "../../../../modules/aws/secretmanager/v1_1_1"
  name        = "${local.prefix}-twingate"
  tags        = local.tags
  kms_key_id  = local.kmsid
  description = "Twingate license for control user"
}

output "secrets_manager_twingate" {
  value = module.secrets_manager_twingate
}

##################################################################################################
# Create Secret - Codefresh
module "secrets_manager_codefresh" {
  source      = "../../../../modules/aws/secretmanager/v1_1_1"
  name        = "${local.prefix}-codefresh"
  tags        = local.tags
  kms_key_id  = local.kmsid
  description = "Codefresh API/Token for control user"
}

output "secrets_manager_codefresh" {
  value = module.secrets_manager_codefresh
}

##################################################################################################
# Create Secret - prometheus
module "secrets_manager_prometheus" {
  source      = "../../../../modules/aws/secretmanager/v1_1_1"
  name        = "${local.prefix}-prometheus"
  tags        = local.tags
  kms_key_id  = local.kmsid
  description = "Prometheus access for control user"
}

output "secrets_manager_prometheus" {
  value = module.secrets_manager_prometheus
}

##################################################################################################
# Create Secret - snyk.io
module "secrets_manager_snyk" {
  source      = "../../../../modules/aws/secretmanager/v1_1_1"
  name        = "${local.prefix_common}-snyk"
  tags        = local.tags_common
  kms_key_id  = local.kmsid
  description = "Snyk.io token access for control user"
}

output "secrets_manager_snyk" {
  value = module.secrets_manager_snyk
}

##################################################################################################
# Create credential - RDS - postgres_supplier
module "secrets_manager_rds_postgres_supplier" {
  source      = "../../../../modules/aws/secretmanager/v1_1_1"
  name        = "${local.prefix}-rds-postgres-supplier"
  tags        = local.tags
  kms_key_id  = local.kmsid
  description = "login credential for rds_postgres_supplier"
}

output "secrets_manager_rds_postgres_supplier" {
  value = module.secrets_manager_rds_postgres_supplier
}

##################################################################################################
# Create credential - RDS - postgres_employee
module "secrets_manager_rds_postgres_employee" {
  source      = "../../../../modules/aws/secretmanager/v1_1_1"
  name        = "${local.prefix}-rds-postgres-employee"
  tags        = local.tags
  kms_key_id  = local.kmsid
  description = "login credential for rds_postgres_employee"
}

output "secrets_manager_rds_postgres_employee" {
  value = module.secrets_manager_rds_postgres_employee
}

##################################################################################################
# Create Secret - mailersend
module "secrets_manager_mailersend" {
  source      = "../../../../modules/aws/secretmanager/v1_1_1"
  name        = "${local.prefix_common}-mailersend"
  tags        = local.tags_common
  kms_key_id  = local.kmsid
  description = "mailersend token access for control user"
}

output "secrets_manager_mailersend" {
  value = module.secrets_manager_mailersend
}
