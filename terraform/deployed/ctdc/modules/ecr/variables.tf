variable "tags" {
  description = "tags to label this ALB"
  type        = map(string)
  default     = {}
}
variable "stack_name" {
  description = "Name of the project"
  type        = string
}
variable "create_ecr_repos" {
  description = "do we create ecr repos"
  default     = false
  type        = bool
}