module "ecr" {
  source = "./modules/ecr"
  
  app = var.app
  
}
