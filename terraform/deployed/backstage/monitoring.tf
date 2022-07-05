module "monitoring" {
  source = "./modules/monitoring"

  app                  = var.app
  tags                 = var.tags
  sumologic_access_id  = var.sumologic_access_id
  sumologic_access_key = var.sumologic_access_key

}