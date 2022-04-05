public_subnet_ids = []
private_subnet_ids = [
  "subnet-4f35f112",
  "subnet-409a0424"
]
vpc_id = "vpc-29a12251"
stack_name = "icdc"
app_name = "icdc"
domain_name = "cancer.gov"

tags = {
  Project = "icdc"
  CreatedWith = "Terraform"
  POC = "ye.wu@nih.gov"
  Environment = "dev"
}
fargate_security_group_ports = ["80","443","3306","7473","7474","9200","7687"]
certificate_domain_name = "*.cancer.gov"
allowed_subnet_ip_block = ["10.208.0.0/21","10.210.0.0/24"]
app_sub_domain = "caninecommons"
elasticsearch_version = "OpenSearch_1.1"
region = "us-east-1"
elasticsearch_instance_type = "t3.medium.elasticsearch"
create_es_service_role = false
internal_alb = true
app_ecr_registry_names = ["backend","frontend","auth"]
microservices  = {
  frontend = {
    name = "frontend"
    port = 80
    health_check_path = "/"
    priority_rule_number = 22
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
    image_url = "cbiitssrepo/bento-backend:latest"
    cpu = 512
    memory = 1024
    path = "/v1/graphql/*"
  },
  auth = {
    name = "auth"
    port = 8082
    health_check_path = "/api/auth/ping"
    priority_rule_number = 21
    image_url = "cbiitssrepo/bento-auth:latest"
    cpu = 256
    memory = 512
    path = "/api/auth/*"
  },
  files = {
    name = "files"
    port = 8081
    health_check_path = "/api/files/ping"
    priority_rule_number = 19
    image_url = "cbiitssrepo/bento-filedownloader:latest"
    cpu = 256
    memory = 512
    path = "/api/files/*"
  }

}
cloud_platform = "cloudone"
create_dns_record = false