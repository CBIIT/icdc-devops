public_subnets = [
  "subnet-9e9907fa",
  "subnet-ed3efab0"
]
private_subnets = [
  "subnet-a69608c2",
  "subnet-f334f0ae"
]
vpc_id = "vpc-c29e1dba"
stack_name = "gmb"
app_name = "gmb"
domain_name = "cancer.gov"
tags = {
  Project = "GMB"
  CreatedWith = "Terraform"
  POC = "ye.wu@nih.gov"
}
certificate_domain_name = "*.cancer.gov"
backend_container_port = 8080
frontend_container_port = 80
frontend_container_image_name = "cbiitssrepo/bento-frontend"
backend_container_image_name = "cbiitssrepo/bento-backend"
internal_alb = false
app_sub_domain = "prostatenaturalhistory"