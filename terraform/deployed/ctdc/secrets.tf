module "secrets" {
  source = "./modules/secrets"

  app                        = var.stack_name
  es_endpoint                = module.ctdc_elasticsearch.es_endpoint
  neo4j_password             = var.neo4j_password
  db_instance                = var.db_instance
  indexd_url                 = var.indexd_url
  sumo_collector_token_be    = module.monitoring.backend_source_url
  sumo_collector_token_fe    = module.monitoring.frontend_source_url
  sumo_collector_token_files = module.monitoring.files_source_url

}