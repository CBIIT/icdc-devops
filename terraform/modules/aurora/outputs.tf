
output "cluster_endpoint" {
  value = aws_rds_cluster.rds.endpoint
}
output "db_password" {
  value = random_password.master_password.result
  sensitive = false

}