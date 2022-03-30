public_subnets = []
private_subnets = [
  "subnet-8832f6d5",
  "subnet-819c02e5"
]
vpc_id = "vpc-dca724a4"
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
internal_alb = true
app_sub_domain = "prostatenaturalhistory"