variable "username" {
  type        = string
  description = "the name of the user"
}

variable "email" {
  type        = string
  description = "the email of the user"
}

variable "fullname" {
  type        = string
  description = "The user fullname"
}

variable "forcedreset" {
  type        = number
  description = "Allow user account password reset"
  default     = 0
}

variable "tags" {
  type        = map(string)
  description = "List of tags"
}

variable "policy_arns" {
  description = "The custom policy ARNs to be attached to the user"
  type        = list(string)
  default     = []
}

variable "groups" {
  description = "The user groups to be attached to the user"
  type        = list(string)
  default     = []
}
