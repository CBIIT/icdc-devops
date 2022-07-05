module "ecs" {
  source = "./modules/ecs"

  app                 = var.app
  tags                = var.tags
  container_replicas  = 1
  target_group_arn    = module.alb.target_group_arn
  alb_sg_id           = module.alb.alb_security_group_id
  vpc_id              = var.vpc_id
  public_subnets      = var.public_subnet_ids
  private_subnets     = var.private_subnet_ids
  use_cbiit_iam_roles = var.use_cbiit_iam_roles

}
