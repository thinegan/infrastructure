variable "name" {
  description = "the name of the eks cluster name"
  default     = "null"
}

variable "pod" {
  description = "A mapping of tags to assign to the eks"
  default     = "null"
}

variable "environment" {
  description = "A environment of tags to assign to the eks"
  default     = "null"
}

variable "vpcid" {
  description = "VPC id"
  default     = "null"
}

variable "kmsid" {
  description = "KMS ARN setup"
  default     = "null"
}

variable "secretmanagerid" {
  description = "AWS Secret Manager"
  type        = map(string)
  default     = {}
}

variable "public_subnet_ids" {
  description = "public subnet ids"
  type        = list(string)
  default     = []
}

variable "private_subnet_ids" {
  description = "private subnet ids"
  type        = list(string)
  default     = []
}

variable "gen1_node_group" {
  description = "EKS Node Group"
  default     = "null"
}

variable "gen1_instance_type" {
  description = "EKS Instance type"
  default     = "null"
}

variable "gen1_capacity_type" {
  description = "EKS Capacity type"
  default     = "null"
}

variable "gen1_min_size" {
  description = "Minimum Number of Cluster Node(s)"
}

variable "gen1_max_size" {
  description = "Maximum Number of Cluster Node(s)"
}

variable "gen1_desired_size" {
  description = "Desired Number of Cluster Node(s)"
}
