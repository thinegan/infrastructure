# Codefresh Pipeline Setup
Codefresh is the most trusted platform for cloud-native apps.

## Prerequisites Notes
As a 3rd Party CI/CD tool, subscription to this service is required. The basic plan, free for up to 3 user accesses, is available for testing purposes. Begin by configuring GitHub authentication and establishing a basic shared credential/key set: shared_variable = ["AWS_STAGING", "SNYK", "GIT_COMMIT"].

Before proceeding with Codefresh configuration updates, ensure the Codefresh service is installed. The pre-setup involves the installation of Codefresh Runner, and you can refer to an example Helm installation guide at: https://artifacthub.io/packages/helm/codefresh-runner/cf-runtime.

Post-setup for Codefresh includes the installation of projects and pipelines.

## Tested on the following Region:
 - US East (N. Virginia)

## Quickstart
Make sure awscli is configured using `aws configure`, or the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` are properly exported into the environment.

Run Terraform Install:

```bash
terraform init
terraform plan -out=plan.tfplan
terraform apply "plan.tfplan"
```

Run Terraform Uninstall:

```bash
terraform destroy -auto-approve
```

### Example Setup

```hcl
# Create Project
resource "codefresh_project" "project_mytutorial1" {
  name = "MyTutorial1"
  tags = [
    "staging",
    "DEVOPS",
  ]
}

# Create Pipeline
locals {
  local_cluster      = "minihp"
  staging_cluster    = "stag-eks-test4"
  production_cluster = "prod-eks-general2"
  staging_nginx      = "stag-eks-test6"
  staging_fargate    = "stag-eks-test6"
  staging_alb        = "stag-eks-test6"
  staging_istio      = "stag-eks-test6"
}

#############################################################################################################
# Project : MyTutorial1
# module ref : https://registry.terraform.io/providers/codefresh-io/codefresh/latest/docs/resources/pipeline
#############################################################################################################
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
```

## Author

Thinegan Ratnam
 - [http://thinegan.com](http://thinegan.com/)

## Copyright and License

Copyright 2024 Thinegan Ratnam

Code released under the MIT License.