public_subnets = [
  "subnet-03bb1c845d35aacc5",
  "subnet-0a575f7e0c97cad77"
]
public_subnets = [
  "subnet-09b0c7407416d4730",
  "subnet-07d177a4d9df5cd32"
]
vpc_id = "vpc-08f154f94dc8a0e34"
stack_name = "ccdi"
app_name = "oasis"
profile = "icdc"
domain_name = "bento-tools.org"
tags = {
  Project = "CCDI"
  CreatedWith = "Terraform"
  POC = "user@example.com"
}
certificate_domain_name = "*.bento-tools.org"
backend_container_port = 8080
frontend_container_port = 80
app_url = "ccdi-test.bento-tools.org"
frontend_container_image_name = "cbiitssrepo/bento-frontend"
backend_container_image_name = "cbiitssrepo/bento-backend"