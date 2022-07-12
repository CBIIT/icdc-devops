variable "app" {
  description = "name of the app"
  type        = string
}
variable "sumo_collector_token" {
  type        = string
  description = "Sumo collector token"
}
variable "postgres_password" {
  type        = string
  description = "postgres password"
}
variable "postgres_endpoint" {
  type        = string
  description = "postgres endpoint"
}
variable "github_token" {
  type        = string
  description = "github token"
}