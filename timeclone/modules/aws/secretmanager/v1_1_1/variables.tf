variable "name" {
  description = "name of the secret manager"
  default     = "null"
  type        = string
}

variable "description" {
  description = "description of the secret manager"
  default     = "null"
  type        = string
}

variable "kms_key_id" {
  description = "kms id to use"
  default     = "null"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "List of tags"
}
