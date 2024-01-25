variable "name" {
  description = "the name of the VPC"
  default     = "null"
}

variable "cidr" {
  description = "cidr ip block"
  default     = "null"
}

variable "environment" {
  description = "A environment of tags to assign to the vpc"
  default     = "null"
}

variable "azs" {
  type        = list(string)
  description = "A list of availability zones specified as argument to this module"
  default     = []
}

variable "public_subnets" {
  type        = list(string)
  description = "List of IDs of public subnets"
  default     = []
}

variable "private_subnets" {
  type        = list(string)
  description = "List of IDs of private subnets"
  default     = []
}

variable "database_subnets" {
  type        = list(string)
  description = "List of IDs of database subnets"
  default     = []
}

