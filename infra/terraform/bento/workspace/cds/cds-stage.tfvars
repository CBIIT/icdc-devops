public_subnet_ids = []
private_subnet_ids = [
  "subnet-f334f0ae",
  "subnet-a69608c2"
]
vpc_id = "vpc-c29e1dba"
stack_name = "cds"

tags = {
  Project = "cds"
  CreatedWith = "Terraform"
  POC = "ye.wu@nih.gov"
  Environment = "stage"
}
region = "us-east-1"

#alb
internal_alb = false
certificate_domain_name = "cds-stage.datacommons.cancer.gov"
domain_name = "datacommons.cancer.gov"

#ecr
create_ecr_repos = false
ecr_repo_names = ["backend","frontend"]

#ecs
add_opensearch_permission = true
application_subdomain = "cds"
microservices  = {
  frontend = {
    name = "frontend"
    port = 80
    health_check_path = "/"
    priority_rule_number = 22
    image_url = "cbiitssrepo/bento-frontend:latest"
    cpu = 256
    memory = 512
    path = ["/*"]
    number_container_replicas = 1
  },
  backend = {
    name = "backend"
    port = 8080
    health_check_path = "/ping"
    priority_rule_number = 20
    image_url = "cbiitssrepo/bento-backend:latest"
    cpu = 512
    memory = 1024
    path = ["/v1/graphql/*","/version"]
    number_container_replicas = 1
  }
}

#opensearch
create_opensearch_cluster = true
opensearch_ebs_volume_size = 200
opensearch_instance_type = "t3.medium.search"
opensearch_version = "OpenSearch_1.2"
allowed_ip_blocks = ["10.208.0.0/21","10.210.0.0/24","10.208.8.0/21"]
create_os_service_role = true
opensearch_instance_count = 1
create_cloudwatch_log_policy = true


#neo4j db is created by cloudone
create_db_instance = false

#dns is managed by cloudone
create_dns_record = false

#cloud platform
cloud_platform="cloudone"
target_account_cloudone = true
create_instance_profile = false

#cloudfront
create_cloudfront = false
create_files_bucket = false
cloudfront_distribution_bucket_name = "cds-nonprod-annotation-files"
cloudfront_slack_channel_name = "cds-cloudfront-wafv2"
alarms = {
  error4xx = {
    name = "4xxErrorRate"
    threshold = 10
  }
  error5xx = {
    name = "5xxErrorRate"
    threshold = 10
  }
}
slack_secret_name = "cloudfront-slack"