locals {
  db_port = 5432
  protocol = "tcp"
  all_ips  = ["0.0.0.0/0"]
  any = "-1"
  database_name = "backstage"
  db_instance_class = "db.serverless"
  db_engine = "aurora-postgresql"
  db_engine_version = "13.6"
  #db_engine_mode = "serverless"
  minor_version_upgrade = true
  allow_major_version_upgrade = false
  master_username = "postgres"
  master_password_length = 15
  min_capacity = 1
  max_capacity = 2
  storage_encrypted = true
  snapshot_name = "${var.app}-${random_id.snapshot.hex}"
  snapshot_identifier_prefix = "backstage"
  skip_final_snapshot = false
  deletion_protection = false
  backup_retention_period = 35
  backup_window = "04:00-05:00"
  maintenance_window = "sun:00:00-sun:02:00"
  secret_recovery_window_in_days = 0
  enabled_cloudwatch_logs_exports = ["postgresql"]
  availability_zones = []
  enable_http_endpoint = false

}