module "secrets" {
  source = "./modules/secrets"

  app                  = var.app
  sumo_collector_token = module.monitoring.backstage_source_url
  postgres_password    = module.database.master_password
  postgres_endpoint    = module.database.cluster_endpoint
  github_token         = var.github_token

}