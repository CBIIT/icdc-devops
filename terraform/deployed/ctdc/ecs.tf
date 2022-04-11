module "ctdc_ecs" {
  source = "./modules/ecs"
  
  stack_name = var.stack_name
  tags = var.tags
  container_replicas = 1
  frontend_target_group_arn = module.alb.frontend_target_group_arn
  backend_target_group_arn = module.alb.backend_target_group_arn
  
}
