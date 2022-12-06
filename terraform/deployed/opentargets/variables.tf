variable "domain_name" {
  description = "domain name for the application"
  type = string
}
variable "profile" {
  description = "iam user profile to use"
  type = string
}

variable "remote_state_bucket_name" {
  description = "name of the terraform remote state bucket"
  type = string
}
variable "region" {
  description = "aws region to deploy"
  type = string
}
variable "ssh_user" {
  type = string
  description = "name of the ec2 user"
}
variable "env" {
  description = "environment"
  type = string
}

variable "app" {
  description = "name of the frontend app"
  type = string
}
variable "program" {
  description = "name of the program"
  type = string
  default = "ccdi"

}
variable "instance_type" {
  description = "ec2 instance type to use"
  type = string
}
variable "ssh_key_name" {
  description = "name of the ssh key to manage the instances"
  type = string
}
variable "ebs_volume_type" {
  description = "EVS volume type"
  default = "standard"
  type = string
}
variable "instance_volume_size" {
  description = "volume size of the instances"
  type = number
}
variable "tags" {
  description = "tags to associate with this instance"
  type = map(string)
}
variable "alb_name" {
  description = "Name for the ALB"
  type = string
  default = "alb"
}