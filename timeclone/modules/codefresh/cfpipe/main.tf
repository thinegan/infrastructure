// AWS Provider
provider "aws" {
  region = "us-east-1"
}

##############################################################################################################
## Pipeline Setup
## ref : https://registry.terraform.io/providers/codefresh-io/codefresh/latest/docs/resources/pipeline
##############################################################################################################
resource "codefresh_pipeline" "this" {

  name = var.name
  tags = var.tags

  spec {
    priority            = 0
    concurrency         = 0
    branch_concurrency  = 0
    trigger_concurrency = 0

    spec_template {
      repo     = var.repo
      path     = var.path
      revision = var.revision
      context  = "githubcodefresh12"
    }

    # (List of String) A list of strings representing the contexts (shared_configuration) to be configured for the pipeline.
    contexts = var.shared_variable
    runtime_environment {
      name   = var.runtime_env
      cpu    = var.runtime_cpu
      memory = var.runtime_memory
    }

    trigger {
      branch_regex_input = "multiselect"
      branch_regex       = "/master/gi"
      context            = "githubcodefresh12"
      description        = "Trigger for commits"
      disabled           = var.disable_trigger
      events = [
        "push.heads"
      ]
      modified_files_glob = var.mod_files_blob
      name                = "commits"
      provider            = "github"
      repo                = var.repo
      type                = "git"
    }
  }
}
