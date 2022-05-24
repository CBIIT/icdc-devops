module "monitoring" {
  source = "./modules/monitoring"

  app = var.stack_name
  tags = var.tags 
  sumologic_access_id = var.sumologic_access_id
  sumologic_access_key = var.sumologic_access_key

}