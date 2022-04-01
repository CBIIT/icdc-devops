variable "tags" {
  description = "tags to associate with this instance"
  type = map(string)
}
variable "stack_name" {
  description = "name of the project"
  type = string
}
variable "ssh_key_name" {
  description = "name of the ssh key to manage the instances"
  type = string
}
variable "ssh_user" {
  description = "name of the ec2 user"
   type = string
   default = ""
}
variable "private_subnet_ids" {
  description = "list of subnet ids to use"
  type = list(string)
  default = null
}
variable "database_instance_type" {
  description = "ec2 instance type to use"
  type = string
  default = "t3.medium"
}
variable "database_name" {
  description = "name of the database"
  type = string
  default = "neo4j"
}
variable "evs_volume_type" {
  description = "EVS volume type"
  type = string
  default = "standard"
}
variable "db_instance_volume_size" {
  description = "volume size of the instances"
  type = number
  default = 80
}
variable "vpc_id" {
  description = "vpc id"
  type = string
}