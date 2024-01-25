variable "name" {
  description = "the name of the rds"
}

variable "engine" {
  description = "rds engine"
}

variable "engine_version" {
  description = "rds engine version"
}

variable "family" {
  description = "rds engine family DB Parameter Group"
}

variable "instance_class" {
  description = "instance_class size"
}

variable "allocated_storage" {
  description = "storage size"
}

variable "environment" {
  description = "Environment"
}

variable "jdbc_username" {
  description = "jdbc_username"
}

variable "jdbc_password" {
  description = "jdbc_password"
}

variable "port" {
  description = "port"
}

variable "pod" {
  description = "A mapping of tags to assign to the rds"
}
