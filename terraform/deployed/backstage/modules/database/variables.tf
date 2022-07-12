variable "app" {
  description = "name of the project"
  type = string
}

variable "db_subnet_ids" {
  type        = list(string)
  default     = []
  description = "list of subnet IDs to use"
}

variable "allowed_ip_blocks" {
  type        = list(string)
  default     = []
  description = "list of allowed IP blocks"
}

variable "ecs_security_group_id" {
  type        = string
  description = "ecs security group id"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID the DB instance will be created in"
}