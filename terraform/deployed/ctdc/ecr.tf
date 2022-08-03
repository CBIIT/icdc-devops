module "ctdc_ecr" {
  source = "./modules/ecr"
  
  stack_name       = var.stack_name
  create_ecr_repos = var.create_ecr_repos
  
}
