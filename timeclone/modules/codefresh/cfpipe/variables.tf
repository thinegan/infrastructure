variable "name" {
  type        = string
  description = "The display name for the pipeline"
  default     = "null"
}

variable "repo" {
  type        = string
  description = "The repository of the spec template (owner/repo)"
  default     = "null"
}

variable "path" {
  type        = string
  description = "The relative path to the Codefresh pipeline file"
  default     = "null"
}

variable "revision" {
  type        = string
  description = "The git revision of the spec template. Possible values: '', name of branch. Use '' to autoselect a branch"
  default     = ""
}

variable "runtime_env" {
  type        = string
  description = "The runtime environment for the pipeline"
  default     = "minihp/codefresh"
}

variable "runtime_cpu" {
  type        = string
  description = "The CPU allocated to the runtime environment"
  default     = "1400m"
}

variable "runtime_memory" {
  type        = string
  description = "The memory allocated to the runtime environment"
  default     = "4000Mi"
}

variable "shared_variable" {
  type        = list(string)
  description = "A list of strings representing the contexts (shared_configuration) to be configured for the pipeline"
  default     = ["AWS_STAGING"]
}

variable "tags" {
  type        = list(string)
  description = "A list of tags to mark a project for easy management and access control"
  default     = ["staging"]
}

variable "trigger_branch" {
  type        = string
  description = "A regular expression and will only trigger for branches that match this naming pattern"
  default     = "null"
}

variable "mod_files_blob" {
  type        = string
  description = "Allows to constrain the build and trigger it only if the modified files from the commit match this glob expression"
  default     = ""
}

variable "disable_trigger" {
  type        = bool
  description = "Flag to disable the trigger"
  default     = false
}
