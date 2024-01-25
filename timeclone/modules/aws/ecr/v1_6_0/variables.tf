variable "name" {
  description = "The name of the repository"
  type        = string
}

variable "pod" {
  description = "A mapping of tags to assign pod team"
  type        = string
}

variable "environment" {
  description = "A mapping of tags to assign environment"
  type        = string
}

variable "allow_readonly" {
  description = "The ARNs of the aws account that have read access to the repository"
  type        = list(string)
  default     = []
}
