variable "tags" {
  description = "tags to associate with this instance"
  type = map(string)
}
variable "stack_name" {
  description = "name of the project"
  type = string
}
variable "container_replicas" {
  description = "specify the number of container to run"
  type = number
}
variable "alb_sg_id" {
  description = "id of the alb security group"
  type = string
}
variable "frontend_container_port" {
  description = "port on which the container listens"
  type = number
  default = 80
}
variable "frontend_target_group_arn" {
  description = "name of the frontend alb target group"
  type = string
}
variable "backend_container_port" {
  description = "port on which the container listens"
  type = number
  default = 8080
}
variable "backend_target_group_arn" {
  description = "name of the backend alb target group"
  type = string
}
variable "vpc_id" {
  description = "id of the vpc"
  type = string
}
variable "frontend_container_image_name" {
  description = "frontend container image name"
  type = string
  default = "cbiitssrepo/bento-frontend"
}
variable "backend_container_image_name" {
  description = "backend container image name"
  type = string
  default = "cbiitssrepo/bento-backend"
}
variable "ecs_network_mode" {
  description = "ecs network mode - bridge,host,awsvpc"
  type = string
  default = "awsvpc"
}
variable "ecs_launch_type" {
  description = "ecs launch type - FARGATE or EC2"
  type = string
  default = "FARGATE"
}
variable "ecs_scheduling_strategy" {
  description = "ecs scheduling strategy"
  type = string
  default = "REPLICA"
}
variable "fronted_rule_priority" {
  description = "priority number to assign to alb rule"
  type = number
  default = 101
}
variable "backend_rule_priority" {
  description = "priority number to assign to alb rule"
  type = number
  default = 100
}
variable "public_subnets" {
  description = "Provide list of public subnets to use in this VPC. Example 10.0.1.0/24,10.0.2.0/24"
  default     = []
  type = list(string)
}
variable "private_subnets" {
  description = "Provide list private subnets to use in this VPC. Example 10.0.10.0/24,10.0.11.0/24"
  default     = []
  type = list(string)
}