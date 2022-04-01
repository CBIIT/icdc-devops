variable "tags" {
  description = "tags to associate with this instance"
  type = map(string)
}
variable "stack_name" {
  description = "name of the project"
  type = string
}
variable "database_instance_type" {
  description = "ec2 instance type to use"
  type = string
}
variable "ssh_key_name" {
  description = "name of the ssh key to manage the instances"
  type = string
}
variable "private_subnet_ids" {
  description = "list of subnet ids to use"
  type = list(string)
  default = null
}