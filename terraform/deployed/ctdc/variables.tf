variable "tags" {
  description = "tags to associate with this instance"
  type = map(string)
}
variable "stack_name" {
  description = "name of the project"
  type = string
}
variable "region" {
  description = "aws region to deploy"
  type = string
  default = "us-east-1"
}
variable "profile" {
  description = "iam user profile to use"
  type = string
  default = "default"
}

variable "remote_state_bucket_name" {
  description = "name of the remote bucket to store or pull terraform state data"
  type = string
  default = null
}
variable "create_es_service_role" {
  type = bool
  default = false
  description = "change this value to true if running this script for the first time"
}
variable "private_subnet_ids" {
  description = "list of subnet ids to use"
  type = list(string)
  default = null
}
variable "vpc_id" {
  description = "vpc id"
  type = string
}
variable "subnet_ip_block" {
  description = "subnet ip block"
  type = list(string)
}