variable "stack_name" {
  description = "name of the project"
  type = string
}
variable "tags" {
  description = "tags to associate with this instance"
  type = map(string)
}

variable "vpc_id" {
  description = "vpc id to to launch the ALB"
  type        = string
}

variable "region" {
  description = "aws region to use for this resource"
  type = string
  default = "us-east-1"
}

variable "enable_version" {
  description = "enable bucket versioning"
  default = false
  type = bool
}
variable "lifecycle_rule" {
  description = "object lifecycle rule"
  type = any
  default = []
}
variable "certificate_domain_name" {
  description = "domain name for the ssl cert"
  type = string
}

variable "cloud_platform" {
  description = "choose cloud platform to use. We have two - leidos or cloudone"
  default = "leidos"
  type = string
}
variable "internal_alb" {
  description = "is this alb internal?"
  default = false
  type = bool
}
variable "lb_type" {
  description = "Type of loadbalancer"
  type = string
  default = "application"
}
variable "aws_account_id" {
  type = map(string)
  description = "aws account to allow for alb s3 logging"
  default = {
    us-east-1 = "127311923021"
  }
}
variable "public_subnet_ids" {
  description = "Provide list of public subnets to use in this VPC. Example 10.0.1.0/24,10.0.2.0/24"
  type = list(string)
}

variable "private_subnet_ids" {
  description = "Provide list private subnets to use in this VPC. Example 10.0.10.0/24,10.0.11.0/24"
  type = list(string)
}

variable "attach_bucket_policy" {
  description = "set to true if you want bucket policy and provide value for policy variable"
  type        = bool
  default     = true
}
variable "microservices" {
  type = map(object({
    name = string
    port = number
    health_check_path = string
    priority_rule_number = number
    image_url = string
    cpu = number
    memory = number
    path = list(string)
    number_container_replicas = number
  }))
}
variable "domain_name" {
  description = "domain name for the application"
  type = string
}

variable "application_subdomain" {
  description = "subdomain of the app"
  type = string
}
variable "s3_force_destroy" {
  description = "force destroy bucket"
  default = true
  type = bool
}
variable "ecr_repo_names" {
  description = "list of repo names"
  type = list(string)
}
variable "create_ecr_repos" {
  type = bool
  default = false
  description = "choose whether to create ecr repos or not"
}
variable "allowed_ip_blocks" {
  description = "allowed ip block for the opensearch"
  type = list(string)
  default = []
}

variable "create_dns_record" {
  description = "choose to create dns record or not"
  type = bool
  default = true
}

variable "create_env_specific_repo" {
  description = "choose to create environment specific repo. Example bento-dev-frontend"
  type = bool
  default = false
}

variable "target_account_cloudone"{
  description = "to add check conditions on whether the resources are brought up in cloudone or not"
  type        = bool
  default =   false
}
variable "iam_prefix" {
  type = string
  default = "power-user"
  description = "nci iam power user prefix"
}

variable "db_subnet_ids" {
  type        = list(string)
  default     = []
  description = "list of subnet IDs to use"
}
variable "db_engine_mode" {
  type        = string
  default     = "serverless"
  description = "The database engine mode."
}
variable "db_engine_version" {
  description = "aurora database engine version."
  type        = string
  default     = "5.6.10a"
}
variable "db_engine_type" {
  description = "Aurora database engine type"
  type        = string
  default     = "aurora-mysql"
}
variable "db_instance_class" {
  description = "Instance type to use for the db"
  type        = string
  default     = "db.serverless"
}
variable "master_username" {
  description = "username for this db"
  type        = string
  default     = ""
  sensitive   = true
}
variable "database_name" {
  description = "name of the database"
  type = string
  default = "bento"
}
variable "create_aurora_rds" {
  description = "create rds or not"
  type = bool
  default = false
}
variable "project_name" {
  type = string
  default = "bento"
  description = "project name"
}
variable "program" {
  type = string
  default = "crdc"
  description = "program name"
}
variable "enable_s3_replication" {
  description = "create s3 replication"
  type = bool
  default = false
}
variable "enable_metric_pipeline" {
  description = "enable metric pipeline"
  type = bool
  default = false
}
variable "http_endpoint_access_key" {
  description = "new relic http api key"
  type = string
  default = null
}
variable "new_relic_account_id" {
  description = "new relic account id"
  type = string
  default = null
}