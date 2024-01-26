# Codefresh Pipeline module

The central component of the Codefresh Platform. Pipelines are workflows that contain individual steps. Each step is responsible for a specific action in the process.

## Usage Example


### Private Repository

```hcl
locals {
  staging_alb        = "stag-eks-test6"
}

module "codefresh_pipeline_js_production" {
  source = "modules/codefresh/cfpipe"
  name   = "MyTutorial1/templatejs-production"
  repo   = "crytera/templatejs"
  path   = "./cf-pipelines/templatejs-production-cicd.yaml"

  # Use '' to autoselect a branch in revision
  revision        = ""

  # Use shared variable that you pre-configured in codefresh
  shared_variable = ["AWS_STAGING", "SNYK", "GIT_COMMIT"]

  runtime_env     = "${local.staging_alb}/codefresh"
  tags            = ["staging", "DEVOPS", "jscript"]
  runtime_cpu     = "1600m"
  trigger_branch  = "master"
  mod_files_blob  = "!cf-pipelines/*dnsupdate.yaml"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.4.0 |
| <a name="provider_codefresh"></a> [codefresh](#provider\_codefresh) | >= 0.4.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [modules/codefresh/cfpipe.this](https://registry.terraform.io/providers/codefresh-io/codefresh/latest/docs/resources/pipeline) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The display name for the pipeline | `string` | `""` | yes |
| <a name="input_repo"></a> [repo](#input\_repo) | The repository of the spec template (owner/repo) | `string` | `""` | yes |
| <a name="input_path"></a> [path](#input\_path) | The relative path to the Codefresh pipeline file | `string` | `""` | yes |
| <a name="input_revision"></a> [revision](#input\_revision) | The git revision of the spec template. Possible values: '', name of branch. Use '' to autoselect a branch | `string` | `""` | yes |
| <a name="input_runtime_env"></a> [runtime_env](#input\_runtime\_env) | The runtime environment for the pipeline | `string` | `""` | yes |
| <a name="input_runtime_cpu"></a> [runtime_cpu](#input\_runtime\_cpu) | The CPU allocated to the runtime environment | `string` | `""` | yes |
| <a name="input_runtime_memory"></a> [runtime_memory](#input\_runtime\_memory) | The memory allocated to the runtime environment | `string` | `""` | yes |
| <a name="input_shared_variable"></a> [shared_variable](#input\_shared\_variable) | A list of strings representing the contexts (shared_configuration) to be configured for the pipeline | `list(string)` | `[]` | yes |
| <a name="input_trigger_branch"></a> [trigger_branch](#input\_trigger\_branch) | A regular expression and will only trigger for branches that match this naming pattern | `string` | `""` | yes |
| <a name="input_mod_files_blob"></a> [mod_files_blob](#input\_mod\_files\_blob) | Allows to constrain the build and trigger it only if the modified files from the commit match this glob expression | `string` | `""` | no |
| <a name="input_disable_trigger"></a> [disable_trigger](#input\_disable\_trigger) | Flag to disable the trigger | `bool` | `"true/false"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A list of tags to mark a project for easy management and access control | `list(string)` | `[]` | yes |

## Outputs

| Name | Description |
|------|-------------|
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

