
locals {
  local_cluster      = "minihp"
  staging_cluster    = "stag-eks-test4"
  production_cluster = "prod-eks-general2"
  staging_nginx      = "stag-eks-test6"
  staging_fargate    = "stag-eks-test6"
  staging_alb        = "stag-eks-test6"
  staging_istio      = "stag-eks-test6"
}

########################################################################################################################
# Project : MyTutorial1
# module ref : https://registry.terraform.io/providers/codefresh-io/codefresh/latest/docs/resources/pipeline
########################################################################################################################
module "codefresh_pipeline_js_production" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/templatejs-production"
  repo   = "crytera/templatejs"
  path   = "./cf-pipelines/templatejs-production-cicd.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "SNYK", "GIT_COMMIT"]
  runtime_env     = "${local.staging_alb}/codefresh"
  tags            = ["staging", "DEVOPS", "jscript"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "!cf-pipelines/*dnsupdate.yaml"
}

module "codefresh_pipeline_js_staging_dnsupdate" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/templatejs-staging-dnsupdate"
  repo   = "crytera/templatejs"
  path   = "./cf-pipelines/templatejs-staging-dnsupdate.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "CLOUDFLARE"]
  runtime_env     = "${local.staging_alb}/codefresh"
  tags            = ["staging", "DEVOPS", "jscript"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "cf-pipelines/templatejs-staging-dnsupdate.yaml"
}

module "codefresh_pipeline_js_production_dnsupdate" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/templatejs-production-dnsupdate"
  repo   = "crytera/templatejs"
  path   = "./cf-pipelines/templatejs-production-dnsupdate.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "CLOUDFLARE"]
  runtime_env     = "${local.staging_alb}/codefresh"
  tags            = ["staging", "DEVOPS", "jscript"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "cf-pipelines/templatejs-production-dnsupdate.yaml"
}

module "codefresh_pipeline_phpfpm_production" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/phpfpm-production"
  repo   = "crytera/templatephpfpm"
  path   = "./cf-pipelines/templatephpfpm-production-cicd.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "SNYK", "GIT_COMMIT", "SONARQUBE"]
  runtime_env     = "${local.staging_alb}/codefresh"
  tags            = ["staging", "DEVOPS", "php"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "!cf-pipelines/*dnsupdate.yaml"
}


module "codefresh_pipeline_phpfpm_staging_dnsupdate" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/phpfpm-staging-dnsupdate"
  repo   = "crytera/templatephpfpm"
  path   = "./cf-pipelines/templatephpfpm-staging-dnsupdate.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "CLOUDFLARE"]
  runtime_env     = "${local.staging_alb}/codefresh"
  tags            = ["staging", "DEVOPS", "php"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "cf-pipelines/templatephpfpm-staging-dnsupdate.yaml"
}

module "codefresh_pipeline_phpfpm_production_dnsupdate" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/phpfpm-production-dnsupdate"
  repo   = "crytera/templatephpfpm"
  path   = "./cf-pipelines/templateapi-production-dnsupdate.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "CLOUDFLARE"]
  runtime_env     = "${local.staging_alb}/codefresh"
  tags            = ["staging", "DEVOPS", "java"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "cf-pipelines/templateapi-production-dnsupdate.yaml"
}

module "codefresh_pipeline_nginx_production" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/templatenginx-production"
  repo   = "crytera/templatenginx"
  path   = "./cf-pipelines/templatenginx-production-cicd.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "SNYK", "GIT_COMMIT"]
  runtime_env     = "${local.staging_nginx}/codefresh"
  tags            = ["staging", "DEVOPS", "java"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "!cf-pipelines/*dnsupdate.yaml"
}

module "codefresh_pipeline_nginx_staging_dnsupdate" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/templatenginx-staging-dnsupdate"
  repo   = "crytera/templatenginx"
  path   = "./cf-pipelines/templatenginx-staging-dnsupdate.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "CLOUDFLARE"]
  runtime_env     = "${local.staging_nginx}/codefresh"
  tags            = ["staging", "DEVOPS", "java"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "cf-pipelines/templatenginx-staging-dnsupdate.yaml"
}

module "codefresh_pipeline_nginx_production_dnsupdate" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/templatenginx-production-dnsupdate"
  repo   = "crytera/templatenginx"
  path   = "./cf-pipelines/templatenginx-production-dnsupdate.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "CLOUDFLARE"]
  runtime_env     = "${local.staging_nginx}/codefresh"
  tags            = ["staging", "DEVOPS", "java"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "cf-pipelines/templatenginx-production-dnsupdate.yaml"
}

module "codefresh_pipeline_java_production" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/templateapi-production"
  repo   = "crytera/templateapi"
  path   = "./cf-pipelines/templateapi-production-cicd.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "SNYK", "GIT_COMMIT", "K6"]
  runtime_env     = "${local.staging_alb}/codefresh"
  tags            = ["staging", "DEVOPS", "java"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "!cf-pipelines/*dnsupdate.yaml"
}

module "codefresh_pipeline_java_staging_dnsupdate" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/templateapi-staging-dnsupdate"
  repo   = "crytera/templateapi"
  path   = "./cf-pipelines/templateapi-staging-dnsupdate.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "CLOUDFLARE"]
  runtime_env     = "${local.staging_alb}/codefresh"
  tags            = ["staging", "DEVOPS", "java"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "cf-pipelines/templateapi-staging-dnsupdate.yaml"
}

module "codefresh_pipeline_java_production_dnsupdate" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/templateapi-production-dnsupdate"
  repo   = "crytera/templateapi"
  path   = "./cf-pipelines/templateapi-production-dnsupdate.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "CLOUDFLARE"]
  runtime_env     = "${local.staging_alb}/codefresh"
  tags            = ["staging", "DEVOPS", "java"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "cf-pipelines/templateapi-production-dnsupdate.yaml"
}

module "codefresh_pipeline_rollout_canary_production" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/templaterollout-canary-production"
  repo   = "crytera/templaterollout"
  path   = "./canary/cf-pipelines/templaterollout-production-cicd.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "SNYK", "GIT_COMMIT"]
  runtime_env     = "${local.staging_alb}/codefresh"
  tags            = ["staging", "DEVOPS", "nginx"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "{canary/**, !canary/cf-pipelines/*dnsupdate.yaml}"

}

module "codefresh_pipeline_rollout_canary_staging_dnsupdate" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/templaterollout-canary-staging-dnsupdate"
  repo   = "crytera/templaterollout"
  path   = "./canary/cf-pipelines/templaterollout-staging-dnsupdate.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "CLOUDFLARE"]
  runtime_env     = "${local.staging_alb}/codefresh"
  tags            = ["staging", "DEVOPS", "nginx"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "canary/cf-pipelines/templaterollout-staging-dnsupdate.yaml"
}

module "codefresh_pipeline_rollout_canary_production_dnsupdate" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/templaterollout-canary-production-dnsupdate"
  repo   = "crytera/templaterollout"
  path   = "./canary/cf-pipelines/templaterollout-production-dnsupdate.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "CLOUDFLARE"]
  runtime_env     = "${local.staging_alb}/codefresh"
  tags            = ["staging", "DEVOPS", "nginx"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "canary/cf-pipelines/templaterollout-production-dnsupdate.yaml"
}

module "codefresh_pipeline_rollout_bluegreen_production" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/templaterollout-bluegreen-production"
  repo   = "crytera/templaterollout"
  path   = "./bluegreen/cf-pipelines/templaterollout-production-cicd.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "SNYK", "GIT_COMMIT"]
  runtime_env     = "${local.staging_alb}/codefresh"
  tags            = ["staging", "DEVOPS", "nginx"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "{bluegreen/**, !bluegreen/cf-pipelines/*dnsupdate.yaml}"
}

module "codefresh_pipeline_rollout_bluegreen_staging_dnsupdate" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/templaterollout-bluegreen-staging-dnsupdate"
  repo   = "crytera/templaterollout"
  path   = "./bluegreen/cf-pipelines/templaterollout-staging-dnsupdate.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "CLOUDFLARE"]
  runtime_env     = "${local.staging_alb}/codefresh"
  tags            = ["staging", "DEVOPS", "nginx"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "bluegreen/cf-pipelines/templaterollout-staging-dnsupdate.yaml"
}

module "codefresh_pipeline_rollout_bluegreen_production_dnsupdate" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/templaterollout-bluegreen-production-dnsupdate"
  repo   = "crytera/templaterollout"
  path   = "./bluegreen/cf-pipelines/templaterollout-production-dnsupdate.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "CLOUDFLARE"]
  runtime_env     = "${local.staging_alb}/codefresh"
  tags            = ["staging", "DEVOPS", "nginx"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "bluegreen/cf-pipelines/templaterollout-production-dnsupdate.yaml"
}

module "codefresh_pipeline_loadbalancer_production" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/templateloadbalancer-production"
  repo   = "crytera/templateloadbalancer"
  path   = "./cf-pipelines/templateloadbalancer-production-cicd.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "SNYK", "GIT_COMMIT"]
  runtime_env     = "${local.staging_nginx}/codefresh"
  tags            = ["staging", "DEVOPS", "nginx"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "!cf-pipelines/*dnsupdate.yaml"
}

module "codefresh_pipeline_loadbalancer_staging_dnsupdate" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/templateloadbalancer-staging-dnsupdate"
  repo   = "crytera/templateloadbalancer"
  path   = "./cf-pipelines/templateloadbalancer-staging-dnsupdate.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "CLOUDFLARE"]
  runtime_env     = "${local.staging_nginx}/codefresh"
  tags            = ["staging", "DEVOPS", "nginx"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "cf-pipelines/templateloadbalancer-staging-dnsupdate.yaml"
}

module "codefresh_pipeline_loadbalancer_production_dnsupdate" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/templateloadbalancer-production-dnsupdate"
  repo   = "crytera/templateloadbalancer"
  path   = "./cf-pipelines/templateloadbalancer-production-dnsupdate.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "CLOUDFLARE"]
  runtime_env     = "${local.staging_nginx}/codefresh"
  tags            = ["staging", "DEVOPS", "nginx"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "cf-pipelines/templateloadbalancer-production-dnsupdate.yaml"
}

module "codefresh_pipeline_fargate_production" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/templatefargate-production"
  repo   = "crytera/templatefargate"
  path   = "./cf-pipelines/templatefargate-production-cicd.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "SNYK", "GIT_COMMIT"]
  runtime_env     = "${local.staging_fargate}/codefresh"
  tags            = ["staging", "DEVOPS", "java", "serverless"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "!cf-pipelines/*dnsupdate.yaml"
}

module "codefresh_pipeline_fargate_staging_dnsupdate" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/templatefargate-staging-dnsupdate"
  repo   = "crytera/templatefargate"
  path   = "./cf-pipelines/templatefargate-staging-dnsupdate.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "CLOUDFLARE"]
  runtime_env     = "${local.staging_fargate}/codefresh"
  tags            = ["staging", "DEVOPS", "java", "serverless"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "cf-pipelines/templatefargate-staging-dnsupdate.yaml"
}

module "codefresh_pipeline_fargate_production_dnsupdate" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/templatefargate-production-dnsupdate"
  repo   = "crytera/templatefargate"
  path   = "./cf-pipelines/templatefargate-production-dnsupdate.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "CLOUDFLARE"]
  runtime_env     = "${local.staging_fargate}/codefresh"
  tags            = ["staging", "DEVOPS", "java", "serverless"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "cf-pipelines/templatefargate-production-dnsupdate.yaml"
}

module "codefresh_pipeline_istio_production" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/templateistio-production"
  repo   = "crytera/templateistio"
  path   = "./cf-pipelines/templateistio-production-cicd.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "SNYK", "GIT_COMMIT"]
  runtime_env     = "${local.staging_istio}/codefresh"
  tags            = ["staging", "DEVOPS", "nginx", "istio"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "!cf-pipelines/*dnsupdate.yaml"
}

module "codefresh_pipeline_istio_staging_dnsupdate" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/templateistio-staging-dnsupdate"
  repo   = "crytera/templateistio"
  path   = "./cf-pipelines/templateistio-staging-dnsupdate.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "CLOUDFLARE"]
  runtime_env     = "${local.staging_istio}/codefresh"
  tags            = ["staging", "DEVOPS", "nginx", "istio"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "cf-pipelines/templateistio-staging-dnsupdate.yaml"
}

module "codefresh_pipeline_istio_production_dnsupdate" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/templateistio-production-dnsupdate"
  repo   = "crytera/templateistio"
  path   = "./cf-pipelines/templateistio-production-dnsupdate.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "CLOUDFLARE"]
  runtime_env     = "${local.staging_istio}/codefresh"
  tags            = ["staging", "DEVOPS", "nginx", "istio"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "cf-pipelines/templateistio-production-dnsupdate.yaml"
}

module "codefresh_pipeline_nistio_production" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/templatenginxistio-production"
  repo   = "crytera/templatenginxistio"
  path   = "./cf-pipelines/templatenginxistio-production-cicd.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "SNYK", "GIT_COMMIT"]
  runtime_env     = "${local.staging_istio}/codefresh"
  tags            = ["staging", "DEVOPS", "nginx", "istio"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "!cf-pipelines/*dnsupdate.yaml"
}

module "codefresh_pipeline_nistio_staging_dnsupdate" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/templatenginxistio-staging-dnsupdate"
  repo   = "crytera/templatenginxistio"
  path   = "./cf-pipelines/templatenginxistio-staging-dnsupdate.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "CLOUDFLARE"]
  runtime_env     = "${local.staging_istio}/codefresh"
  tags            = ["staging", "DEVOPS", "nginx", "istio"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "cf-pipelines/templatenginxistio-staging-dnsupdate.yaml"
}

module "codefresh_pipeline_nistio_production_dnsupdate" {
  source = "../../../modules/codefresh/cfpipe"
  name   = "${codefresh_project.project_mytutorial1.name}/templatenginxistio-production-dnsupdate"
  repo   = "crytera/templatenginxistio"
  path   = "./cf-pipelines/templatenginxistio-production-dnsupdate.yaml"
  # Use '' to autoselect a branch in revision
  revision        = ""
  shared_variable = ["AWS_STAGING", "CLOUDFLARE"]
  runtime_env     = "${local.staging_istio}/codefresh"
  tags            = ["staging", "DEVOPS", "nginx", "istio"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "cf-pipelines/templatenginxistio-production-dnsupdate.yaml"
}
