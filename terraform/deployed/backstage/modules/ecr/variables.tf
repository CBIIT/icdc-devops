variable "tags" {
  description = "tags to use"
  type        = map(string)
  default     = {}
}
variable "app" {
  description = "Name of the project"
  type        = string
}