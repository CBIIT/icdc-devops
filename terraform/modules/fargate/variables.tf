variable "tags" {
  description = "tags to associate with this instance"
  type = map(string)
}
variable "stack_name" {
  description = "name of the project"
  type = string
}
variable "region" {
  description = "aws region to deploy"
  type = string
  default = "us-east-1"
}
variable "profile" {
  description = "iam user profile to use"
  type = string
  default = "default"
}
variable "s3_object_expiration_days" {
  description = "number of days for object to live"
  type = number
  default = 720
}
variable "s3_object_nonactive_expiration_days" {
  description = "number of days to retain non active objects"
  type = number
  default = 90
}
variable "s3_object_standard_ia_transition_days" {
  description = "number of days for an object to transition to standard_ia storage class"
  default = 120
  type = number
}
variable "s3_object_glacier_transition_days" {
  description = "number of days for an object to transition to glacier storage class"
  default = 180
  type = number
}

variable "alb_name" {
  description = "Name for the ALB"
  type = string
  default = "alb"
}
variable "create_alb" {
  description = "choose to create alb or not"
  type = bool
  default = true
}
variable "lb_type" {
  description = "Type of loadbalance"
  type = string
  default = "application"
}
variable "internal_alb" {
  description = "is this alb internal?"
  default = false
  type = bool
}

variable "ssl_policy" {
  description = "specify ssl policy to use"
  default = "ELBSecurityPolicy-2016-08"
  type = string
}

variable "default_message" {
  description = "default message response from alb when resource is not available"
  default = "The requested resource is not available"
}

variable "domain_name" {
  description = "domain name for the application"
  type = string
}

variable "public_subnet_ids" {
  description = "Provide list of public subnets to use in this VPC. Example 10.0.1.0/24,10.0.2.0/24"
  default     = []
  type = list(string)
}

variable "private_subnet_ids" {
  description = "Provide list private subnets to use in this VPC. Example 10.0.10.0/24,10.0.11.0/24"
  default     = []
  type = list(string)
}

variable "vpc_id" {
  description = "VPC Id to to launch the ALB"
  type        = string
}

#added frontend app name to accomodate ppdc-otg and ppdc-otp
variable "app_name" {
  description = "it will be either otp or otg"
  type        = string
}

variable "certificate_domain_name" {
  description = "domain name for the ssl cert"
  type = string
}

variable "aws_account_id" {
  type = map(string)
  description = "aws account to allow for alb s3 logging"
  default = {
    us-east-1 = "127311923021"
  }
}

variable "ecs_launch_type" {
  description = "ecs launch type - FARGATE or EC2"
  type = string
  default = "FARGATE"
}


variable "number_container_replicas" {
  description = "specify the number of container to run"
  type = number
  default = 1
}

variable "ecs_scheduling_strategy" {
  description = "ecs scheduling strategy"
  type = string
  default = "REPLICA"
}

variable "app_sub_domain" {
  description = "url of the app"
  type = string
  default = null
}

variable "ecs_network_mode" {
  description = "ecs network mode - bridge,host,awsvpc"
  type = string
  default = "awsvpc"
}

variable "alb_target_type" {
  type = string
  description = "type of alb target - ip , instance, lambda"
  default = "ip"
}
variable "create_app_ecr_registry" {
  default = true
  description = "create list of registry defined in app_ecr_registry_names"
  type = bool
}

variable "app_ecr_registry_names" {
  type = list(string)
  description = "names of app ecr regis"
  default = ["backend","frontend","auth","files"]
}

variable "microservice_name" {
  type = string
  description = "name of the microservice"
}
variable "microservice_port" {
  type = number
  description = "port on which microservice listens"
  default = 80
}
#variable "microservice_cpu" {
#  type = number
#  description = "cpu requirement for the microservice"
#}
#variable "microservice_memory" {
#  type = number
#  description = "memory requirement for the microservice"
#}
#variable "microservice_health_check_path" {
#  type = string
#  description = "microservice health check path"
#}
#variable "microservice_path" {
#  description = "the path which traffic is routed to the microservice"
#  type = string
#}
#variable "microservice_container_image_name" {
#  description = "the name of the docker image to use for this microservice"
#  type = string
#}
#variable "microservice_priority_rule_number" {
#  description = "priority number to order alb listener rules"
#  type = number
#}
variable "microservice_url" {
  description = "url of the application"
  type = string
}
variable "env" {
  description = "name of the environment to provision"
  type = string
}
variable "alb_subnets" {
  description = "list of subnets to use for the alb"
  type = list(string)
}
variable "alb_allowed_ip_range" {
 description = "allowed subnet range for alb"
  type = list(string)
}
variable "create_dns_record" {
  type = bool
  description = "choose to create dns record"
}
variable "fargate_security_group_ports" {
  type = list(string)
  description = "list of ports to allow when using ECS"
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
    path = string
  }))
}