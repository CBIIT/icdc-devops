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
  create_neo4j_db = var.create_neo4j_db
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