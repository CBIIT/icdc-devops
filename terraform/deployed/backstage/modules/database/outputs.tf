output "cluster_endpoint" {
  value = aws_rds_cluster.rds.endpoint
}

output "master_password" {
  value = aws_rds_cluster.rds.master_password
}