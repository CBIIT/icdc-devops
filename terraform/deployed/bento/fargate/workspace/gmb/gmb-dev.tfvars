public_subnets = []
private_subnets = [
  "subnet-4f35f112",
  "subnet-409a0424"
]
vpc_id = "vpc-29a12251"
stack_name = "gmb"
app_name = "gmb"
domain_name = "cancer.gov"
tags = {
  Project = "GMB"
  CreatedWith = "Terraform"
  POC = "ye.wu@nih.gov"
}
certificate_domain_name = "*.cancer.gov"
internal_alb = true
app_sub_domain = "prostatenaturalhistory"
elasticsearch_instance_type = "t3.medium.elasticsearch"

microservices  = {
  frontend = {
    name = "frontend"
    port = 80
    health_check_path = "/"
    priority_rule_number = 20
    image_url = "cbiitssrepo/bento-frontend:latest"
    cpu = 256
    memory = 512
    path = "/*"
  },
  backend = {
    name = "backend"
    port = 8080
    health_check_path = "/ping"
    priority_rule_number = 20
    image_url = "cbiitssrepo/bento-frontend:latest"
    cpu = 512
    memory = 1024
    path = "/v1/graphql/*"
  },
  frontend = {
    name = "auth"
    port = 8082
    health_check_path = "/api/auth/ping"
    priority_rule_number = 20
    image_url = "cbiitssrepo/bento-auth:latest"
    cpu = 256
    memory = 512
    path = "/api/auth/*"
  }

}