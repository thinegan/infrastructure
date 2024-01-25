variable "name" {
  description = "the name of the bucket"
}

variable "access" {
  description = "The canned ACL to apply. Conflicts with grant"
  default     = null
}

variable "pod" {
  description = "A mapping of tags to assign to the bucket"
}

variable "environment" {
  description = "A mapping of tags to assign to the bucket"
}
