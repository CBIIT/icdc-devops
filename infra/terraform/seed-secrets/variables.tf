variable "region" {
  description = "current aws region"
  type = string
  default = "us-east-1"
}

variable "tags" {
  description = "tags to associate with this instance"
  type = map(string)
}
variable "secret_values" {
  type = map(object({
    secretKey = string
    secretValue = map(string)
  }))
}