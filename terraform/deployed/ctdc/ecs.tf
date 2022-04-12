module "ctdc_ecs" {
  source = "./modules/ecs"
  
  stack_name = var.stack_name
  tags = var.tags
  container_replicas = 1
  frontend_target_group_arn = module.alb.frontend_target_group_arn
  backend_target_group_arn = module.alb.backend_target_group_arn
  alb_sg_id = module.alb.alb_security_group_id
  vpc_id = var.vpc_id
  public_subnets = var.public_subnet_ids
  private_subnets = var.private_subnet_ids
  
}
