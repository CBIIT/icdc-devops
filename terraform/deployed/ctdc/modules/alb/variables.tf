variable "alb_name" {
  description = "Name for the ALB"
  type        = string
  default     = "alb"
}
variable "create_alb" {
  description = "choose to create alb or not"
  type        = bool
  default     = true
}
variable "lb_type" {
  description = "Type of loadbalance"
  type        = string
  default     = "application"
}
variable "internal_alb" {
  description = "is this alb internal?"
  default     = false
  type        = bool
}
variable "subnets" {
  description = "subnets to associate with this ALB"
  type        = list(string)
}
variable "tags" {
  description = "tags to label this ALB"
  type        = map(string)
  default     = {}
}
variable "stack_name" {
  description = "Name of the project"
  type        = string
}
variable "ssl_policy" {
  description = "specify ssl policy to use"
  default     = "ELBSecurityPolicy-2016-08"
  type        = string
}
variable "default_message" {
  description = "default message response from alb when resource is not available"
  default     = "The request resource is not available"
}
variable "certificate_arn" {
  description = "certificate arn to use for the https listner"
  type        = string
}
variable "vpc_id" {
  description = "VPC Id to to launch the ALB"
  type        = string
}
//variable "env" {
//  description = "environment"
//  type        = string
//}

variable "frontend_container_port" {
  description = "port on which the container listens"
  type        = number
  default     = 80
}
variable "backend_container_port" {
  description = "port on which the container listens"
  type        = number
  default     = 8080
}
variable "files_container_port" {
  description = "port on which the container listens"
  type        = number
  default     = 8081
}
variable "fronted_rule_priority" {
  description = "priority number to assign to alb rule"
  type        = number
  default     = 110
}
variable "version_rule_priority" {
  description = "priority number to assign to alb rule"
  type        = number
  default     = 105
}
variable "backend_rule_priority" {
  description = "priority number to assign to alb rule"
  type        = number
  default     = 100
}
variable "files_rule_priority" {
  description = "priority number to assign to alb rule"
  type        = number
  default     = 90
}
variable "domain_url" {
  description = "url to use for this stack"
  type        = string
}

# S3 variables
variable "alb_s3_bucket_name" {
  description = "name of bucket to use for alb logs"
  default     = ""
  type        = string
}
variable "alb_s3_prefix" {
  description = "name of prefix to use for alb logs"
  default     = ""
  type        = string
}
variable "s3_object_expiration_days" {
  description = "number of days for object to live"
  type        = number
  default     = 720
}
variable "s3_object_nonactive_expiration_days" {
  description = "number of days to retain non active objects"
  type        = number
  default     = 90
}
variable "s3_object_standard_ia_transition_days" {
  description = "number of days for an object to transition to standard_ia storage class"
  default     = 120
  type        = number
}
variable "s3_object_glacier_transition_days" {
  description = "number of days for an object to transition to glacier storage class"
  default     = 180
  type        = number
}
variable "create_alb_s3_bucket" {
  description = "do we create alb s3 bucket"
  default     = false
  type        = bool
}