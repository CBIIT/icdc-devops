public_subnet_ids = []
private_subnet_ids = [
  "subnet-8832f6d5",
  "subnet-819c02e5"
]
vpc_id = "vpc-dca724a4"
stack_name = "prefect"

tags = {
  Project = "prefect"
  CreatedWith = "Terraform"
  POC = "ye.wu@nih.gov"
  Environment = "prod"
}
region = "us-east-1"

#alb
internal_alb = true
certificate_domain_name = "*.datacommons.cancer.gov"
domain_name = "datacommons.cancer.gov"

#ecr
create_ecr_repos = true
ecr_repo_names = ["prefect"]

#ecs
application_subdomain = "prefect"
microservices  = {
  frontend = {
    name = "orion"
    port = 4200
    health_check_path = "/"
    priority_rule_number = 22
    image_url = "cbiitssrepo/bento-frontend:latest"
    cpu = 256
    memory = 512
    path = ["/*"]
    number_container_replicas = 1
  }
}

#dns is managed by cloudone
create_dns_record = false

#cloud platform
cloud_platform="cloudone"
target_account_cloudone = true

#metric pipeline
enable_metric_pipeline = true
project_name = "prefect"

#aurora
db_engine_version = "13.3.1"
db_engine_type = "aurora-postgresql"
master_username = "prefect"
allowed_ip_blocks = ["10.208.8.0/21"]
db_subnet_ids = ["subnet-db9f01bf","subnet-1a34f047"]
database_name = "prefect"