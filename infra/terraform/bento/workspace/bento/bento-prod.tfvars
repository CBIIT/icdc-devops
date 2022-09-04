public_subnet_ids = [
  "subnet-082d433b3c4eda6e5",
  "subnet-0e07295b09aba9bff"
]
private_subnet_ids = [
  "subnet-029f8f63b6443f2ce",
  "subnet-0fbfc3beb3a7e95e6"
]
vpc_id = "vpc-0a9a0680d569c28c0"
stack_name = "bento"

tags = {
  Project = "bento"
  CreatedWith = "Terraform"
  POC = "ye.wu@nih.gov"
  Environment = "prod"
}
region = "us-east-1"

#alb
internal_alb = "false"
certificate_domain_name = "*.bento-tools.org"
domain_name = "bento-tools.org"

#ecr
create_ecr_repos = false
ecr_repo_names = ["backend","frontend","auth","files","users"]

#ecs
add_opensearch_permission = true
fargate_security_group_ports = ["80","443","3306","7473","7474","9200","7687"]
application_subdomain = "bento"
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
    path = ["/v1/*","/version","/ping"]
    number_container_replicas = 1
  },
  auth = {
    name = "auth"
    port = 8082
    health_check_path = "/api/auth/ping"
    priority_rule_number = 21
    image_url = "cbiitssrepo/bento-auth:latest"
    cpu = 256
    memory = 512
    path = ["/api/auth/*"]
    number_container_replicas = 1
  },
  files = {
    name = "files"
    port = 8081
    health_check_path = "/api/files/ping"
    priority_rule_number = 19
    image_url = "cbiitssrepo/bento-auth:latest"
    cpu = 256
    memory = 512
    path = ["/api/files/*"]
    number_container_replicas = 1
  },
  users = {
    name = "users"
    port = 8083
    health_check_path = "/api/users/ping"
    priority_rule_number = 18
    image_url = "cbiitssrepo/bento-auth:latest"
    cpu = 256
    memory = 512
    path = ["/api/users/*"]
    number_container_replicas = 1
  }
}

#opensearch
create_opensearch_cluster = true
opensearch_ebs_volume_size = 200
opensearch_instance_type = "t3.medium.search"
opensearch_version = "OpenSearch_1.2"
allowed_ip_blocks = ["10.8.0.0/16","172.16.0.219/32"]
create_os_service_role = false
opensearch_instance_count = 1
create_cloudwatch_log_policy = false


#neo4j db
#katalon_security_group_id = "sg-0f07eae0a9b3a0bb8"
bastion_host_security_group_id = "sg-0c94322085acbfd97"
create_db_instance = true
db_subnet_id = "subnet-029f8f63b6443f2ce"
db_instance_volume_size = 80
ssh_user = "bento"
db_private_ip = "10.8.11.71"
db_iam_instance_profile_name = "bento-dev-ecs-instance-profile"
ssh_key_name = "devops"
public_ssh_key_ssm_parameter_name = "ssh_public_key"
database_instance_type = "t3.large"
#dns
create_dns_record = true
create_instance_profile = false

#create aurora
create_aurora_rds = true
db_engine_mode = "provisioned"
db_engine_version = "8.0"
db_engine_type = "aurora-mysql"
master_username = "bento"
db_instance_class = "db.serverless"
database_name = "bento_session"
db_subnet_ids = [
  "subnet-029f8f63b6443f2ce",
  "subnet-0fbfc3beb3a7e95e6"
]