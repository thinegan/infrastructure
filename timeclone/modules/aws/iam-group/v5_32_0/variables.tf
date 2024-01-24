variable "name" {
  description = "the name of the group"
}

variable "group_policy_arns" {
  description = "The custom policy ARNs to be attached to the group"
  type        = list(string)
  default     = []
}

