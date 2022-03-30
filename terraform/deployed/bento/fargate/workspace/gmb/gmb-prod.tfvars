public_subnets = [
  "subnet-9d9907f9",
  "subnet-a033f7fd"
]
private_subnets = [
  "subnet-8de37de9",
  "subnet-4c35f111"
]
vpc_id = "vpc-0bab2873"
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