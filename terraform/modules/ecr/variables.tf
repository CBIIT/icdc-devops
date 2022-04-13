variable "tags" {
  description = "tags to associate with this instance"
  type = map(string)
}

variable "ecr_names" {
  description = "name of ecr"
  type = list(string)

}

variable "stack_name" {
  description = "name of the project"
  type = string
}