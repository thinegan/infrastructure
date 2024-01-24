variable "name" {
  type        = string
  description = "the name of the policy"
}

variable "description" {
  type        = string
  description = "A short description"
}

variable "policy" {
  type        = string
  description = "string of json variables"
}

variable "tags" {
  type        = map(string)
  description = "List of tags"
}

