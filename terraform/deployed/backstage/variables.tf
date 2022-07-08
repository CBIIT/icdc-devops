variable "tags" {
  description = "tags to associate with this instance"
  type        = map(string)
}
variable "app" {
  description = "name of the project"
  type        = string
}
variable "region" {
  description = "aws region to deploy"
  type        = string
  default     = "us-east-1"
}
variable "profile" {
  description = "iam user profile to use"
  type        = string
  default     = "default"
}
variable "remote_state_bucket_name" {
  description = "name of the remote bucket to store or pull terraform state data"
  type        = string
  default     = null
}
variable "private_subnet_ids" {
  description = "list of private subnet ids to use"
  type        = list(string)
  default     = null
}
variable "public_subnet_ids" {
  description = "list of public subnet ids to use"
  type        = list(string)
  default     = null
}
variable "db_private_ip" {
  description = "private ip address to use for the database"
  type        = string
}
variable "vpc_id" {
  description = "vpc id"
  type        = string
}
variable "subnet_ip_block" {
  description = "subnet ip block"
  type        = list(string)
}
variable "alb_certificate_arn" {
  description = "alb certificate arn"
  type        = string
}
variable "domain_url" {
  description = "url to use for this stack"
  type        = string
}
variable "dns_domain" {
  description = "domain to use for this stack"
  type        = string
}
variable "container_image_name" {
  description = "container image name"
  type        = string
}

# S3 variables
variable "create_alb_s3_bucket" {
  description = "do we create alb s3 bucket"
  type        = bool
  default     = false
}
variable "alb_s3_bucket_name" {
  description = "alb s3 bucket name"
  type        = string
  default     = ""
}
variable "alb_s3_prefix" {
  description = "name of prefix to use for alb logs"
  default     = ""
  type        = string
}

# Monitoring variables
variable "sumologic_access_id" {
  type        = string
  description = "Sumo Logic Access ID"
}
variable "sumologic_access_key" {
  type        = string
  description = "Sumo Logic Access Key"
  sensitive   = true
}

# Role variables - set for cloudone environments
variable "use_cbiit_iam_roles" {
  description = "use CBIIT configurations for IAM roles"
  default     = false
  type        = bool
}