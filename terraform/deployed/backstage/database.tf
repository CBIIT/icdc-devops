module "database" {
  source = "./modules/database"
  
  app = var.app
  db_subnet_ids = var.private_subnet_ids
  ecs_security_group_id  = module.ecs.security_group_id
  allowed_ip_blocks = []
  vpc_id = var.vpc_id

}
