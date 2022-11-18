module "alb" {
  source = "git::https://github.com/CBIIT/datacommons-devops.git//terraform/modules/loadbalancer"
  vpc_id = var.vpc_id
  alb_log_bucket_name = module.s3.bucket_name
  env = terraform.workspace
  alb_internal = var.internal_alb
  alb_type = var.lb_type
  alb_subnet_ids = local.alb_subnet_ids
  tags = var.tags
  stack_name = var.stack_name
  alb_certificate_arn = data.aws_acm_certificate.amazon_issued.arn
}

module "s3" {
  source = "git::https://github.com/CBIIT/datacommons-devops.git//terraform/modules/s3"
  bucket_name = local.alb_log_bucket_name
  stack_name = var.stack_name
  env = terraform.workspace
  tags = var.tags
  s3_force_destroy = var.s3_force_destroy
  days_for_archive_tiering = 125
  days_for_deep_archive_tiering = 180
  s3_enable_access_logging = false
  s3_access_log_bucket_id = ""
}

module "ecs" {
  source = "git::https://github.com/CBIIT/datacommons-devops.git//terraform/modules/ecs"
  stack_name = var.stack_name
  tags = var.tags
  vpc_id = var.vpc_id
  add_opensearch_permission = var.add_opensearch_permission
  ecs_subnet_ids = var.private_subnet_ids
  application_url = local.application_url
  env = terraform.workspace
  microservices = var.microservices
  alb_https_listener_arn = module.alb.alb_https_listener_arn
  target_account_cloudone = var.target_account_cloudone
  allow_cloudwatch_stream = var.allow_cloudwatch_stream
}

#create ecr
module "ecr" {
   count = var.create_ecr_repos ? 1: 0
   source = "git::https://github.com/CBIIT/datacommons-devops.git//terraform/modules/ecr"
   stack_name = var.stack_name
   ecr_repo_names = var.ecr_repo_names
   tags = var.tags
   create_env_specific_repo = var.create_env_specific_repo
   env = terraform.workspace
   enable_ecr_replication = var.enable_ecr_replication
   replication_destination_registry_id = var.replication_destination_registry_id
   replication_source_registry_id = var.replication_source_registry_id 
   allow_ecr_replication = var.allow_ecr_replication
}

#create opensearch
module "opensearch" {
  count = var.create_opensearch_cluster ? 1: 0
  source = "git::https://github.com/CBIIT/datacommons-devops.git//terraform/modules/opensearch"
  stack_name = var.stack_name
  tags = var.tags
  opensearch_instance_type = var.opensearch_instance_type
  env = terraform.workspace
  opensearch_subnet_ids = var.private_subnet_ids
  opensearch_version = var.opensearch_version
  automated_snapshot_start_hour =  var.automated_snapshot_start_hour
  opensearch_ebs_volume_size    =  var.opensearch_ebs_volume_size
  opensearch_instance_count     =  var.opensearch_instance_count
  opensearch_log_types           = ["INDEX_SLOW_LOGS"]
  create_os_service_role        = var.create_os_service_role
  multi_az_enabled = var.multi_az_enabled
  vpc_id = var.vpc_id
  opensearch_autotune_rollback_type = "NO_ROLLBACK"
  create_cloudwatch_log_policy = var.create_cloudwatch_log_policy
}

module "dns" {
  count = var.create_dns_record ? 1: 0
  source = "git::https://github.com/CBIIT/datacommons-devops.git//terraform/modules/route53"
  env = terraform.workspace
  alb_zone_id = module.alb.alb_zone_id
  alb_dns_name = module.alb.alb_dns_name
  application_subdomain = var.application_subdomain
  domain_name = var.domain_name
}

module "neo4j" {
  count = var.create_db_instance ? 1: 0
  source = "git::https://github.com/CBIIT/datacommons-devops.git//terraform/modules/neo4j"
  env = terraform.workspace
  vpc_id = var.vpc_id
  db_subnet_id = var.db_subnet_id
  db_instance_volume_size = var.db_instance_volume_size
  public_ssh_key_ssm_parameter_name = var.public_ssh_key_ssm_parameter_name
  stack_name = var.stack_name
  db_private_ip = var.db_private_ip
  database_instance_type = var.database_instance_type
  tags = var.tags
}

#aurora
module "aurora" {
  count = var.create_aurora_rds ? 1: 0
  source = "git::https://github.com/CBIIT/datacommons-devops.git//terraform/modules/aurora"
  env    =  terraform.workspace
  stack_name = var.stack_name
  tags = var.tags
  vpc_id = var.vpc_id
  db_engine_mode = var.db_engine_mode
  db_engine_version = var.db_engine_version
  db_instance_class = var.db_instance_class
  db_engine_type = var.db_engine_type
  master_username = var.master_username
  allowed_ip_blocks = var.allowed_ip_blocks
  db_subnet_ids = var.db_subnet_ids
  database_name = var.database_name
}

#cloudfront
module "cloudfront" {
  count = var.create_cloudfront ? 1 : 0
  source = "git::https://github.com/CBIIT/datacommons-devops.git//terraform/modules/cloudfront"
  alarms = var.alarms
  domain_name = var.domain_name
  cloudfront_distribution_bucket_name = var.cloudfront_distribution_bucket_name
  cloudfront_slack_channel_name =  var.cloudfront_slack_channel_name
  env = terraform.workspace
  stack_name = var.stack_name
  slack_secret_name = var.slack_secret_name
  tags = var.tags
  create_files_bucket = var.create_files_bucket
  target_account_cloudone = var.target_account_cloudone
  public_key_path = file("${path.module}/workspace/gmb/gmb_public_key.pem")
}

module "s3-replication-source" {
  count = var.create_s3_replication ? 1 : 0
  source = "git::https://github.com/CBIIT/datacommons-devops.git//terraform/modules/s3-replication-source"
  destination_bucket_name = var.destination_bucket_name 
  env =  terraform.workspace
  source_bucket_name = var.source_bucket_name
  stack_name = var.stack_name
  tags = var.tags
  target_account_cloudone = var.target_account_cloudone
  create_source_bucket = var.create_source_bucket 
}

# module "replication" {
#   count = var.create_s3_replication ? 1 : 0
#   source = "git::https://github.com/CBIIT/datacommons-devops.git//terraform/modules/s3-replication"
#   destination_bucket_name = var.destination_bucket_name 
#   env =  terraform.workspace
#   source_bucket_name = var.source_bucket_name
#   stack_name = var.stack_name
#   tags = var.tags
#   target_account_cloudone = var.target_account_cloudone
#   create_destination_bucket = var.create_destination_bucket
#   create_source_bucket = var.create_source_bucket 
#   replication_role_arn = var.replication_role_arn
#   enable_replication = var.enable_replication
# }

# module "new_relic_metric_pipeline" {
#   source = "github.com/CBIIT/datacommons-devops/terraform/modules/firehose-metrics/"
#   count  = terraform.workspace == "dev" || terraform.workspace == "stage" ? 1 : 0
#   account_id                = data.aws_caller_identity.current.account_id
#   app                       = var.project_name
#   http_endpoint_access_key  = var.http_endpoint_access_key (do not store this value in GitHub. Instead, pass this value in when running Terraform Apply operations)
#   level                     = terraform.workspace == "dev"  || terraform.workspace == "qa" ? "non-prod" : "prod"
#   new_relic_account_id      = var.new_relic_account_id (do not store this value in GitHub. Instead, pass this value in when running Terraform Apply operations)
#   permission_boundary_arn   =  local.permission_boundary_arn
#   program                   = var.program #i.e. "crdc"
#   s3_bucket_arn             = var.failed_metric_delivery_bucket #i.e "arn:aws:s3:::example-icdc-destination-bucket"
# }