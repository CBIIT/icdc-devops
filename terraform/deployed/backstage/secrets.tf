module "secrets" {
  source = "./modules/secrets"

  app                  = var.app
  sumo_collector_token = module.monitoring.backstage_source_url

}