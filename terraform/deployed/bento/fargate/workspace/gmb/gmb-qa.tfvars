public_subnet_ids = [
  "subnet-03bb1c845d35aacc5",
  "subnet-0a575f7e0c97cad77"
]
private_subnet_ids = [
  "subnet-09b0c7407416d4730",
  "subnet-07d177a4d9df5cd32"
]
vpc_id = "vpc-08f154f94dc8a0e34"
stack_name = "gmb"
app_name = "gmb"
domain_name = "bento-tools.org"

tags = {
  Project = "gmb"
  CreatedWith = "Terraform"
  POC = "ye.wu@nih.gov"
  Environment = "dev"
}
create_dns_record = true 
fargate_security_group_ports = ["80","443","3306","7473","7474","9200","7687"]
certificate_domain_name = "*.bento-tools.org"
allowed_subnet_ip_block = ["172.18.0.0/16","172.16.0.219/32"]
app_sub_domain = "gmb"
elasticsearch_version = "OpenSearch_1.1"
region = "us-east-1"
elasticsearch_instance_type = "t3.medium.elasticsearch"
create_es_service_role = false
internal_alb = "false"
ecr_names = ["backend","frontend","auth","files"]
create_ecr = false
cloud_platform = "leidos"
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
    image_url = "cbiitssrepo/bento-frontend:latest"
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
#cloudfront
cloudfront_slack_channel_name = "gmb-cloudfront-wafv2"

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
slack_secret_name = "gmb-cloudfront-slack"
create_cloudfront = false
cloudfront_distribution_bucket_name = "gmb-dev-files"