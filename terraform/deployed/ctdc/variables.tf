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
  description = "list of private subnet ids to use"
  type = list(string)
  default = null
}
variable "public_subnet_ids" {
  description = "list of public subnet ids to use"
  type = list(string)
  default = null
}
variable "db_private_ip" {
  description = "private ip address to use for the database"
  type = string
}
variable "vpc_id" {
  description = "vpc id"
  type = string
}
variable "subnet_ip_block" {
  description = "subnet ip block"
  type = list(string)
}
variable "alb_certificate_arn" {
  description = "alb certificate arn"
  type = string
}
variable "create_alb_s3_bucket" {
  description = "do we create alb s3 bucket"
  type = bool
  default = false
}
variable "ssh_key_name" {
  description = "name of the ssh key to manage the instances"
  type = string
}
variable "ssh_user" {
  description = "name of the ssh user"
  type = string
}