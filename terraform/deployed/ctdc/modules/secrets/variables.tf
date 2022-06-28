variable "app" {
  description = "name of the app"
  type        = string
}
variable "es_endpoint" {
  type        = string
  description = "opensearch enpoint for this tier"
}
variable "neo4j_user" {
  type        = string
  description = "neo4j user"
  default     = "neo4j"
}
variable "neo4j_password" {
  type        = string
  description = "neo4j password"
}
variable "indexd_url" {
  type        = string
  description = "indexd url"
  default     = "https://nci-crdc.datacommons.io/user/data/download/dg.4DFC"
}
variable "sumo_collector_token_be" {
  type        = string
  description = "Sumo collector token for backend"
}
variable "sumo_collector_token_fe" {
  type        = string
  description = "Sumo collector token for frontend"
}
variable "sumo_collector_token_files" {
  type        = string
  description = "Sumo collector token for files"
}