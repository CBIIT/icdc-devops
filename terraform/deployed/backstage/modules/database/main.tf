resource "aws_rds_cluster" "rds" {
  cluster_identifier = "${var.app}-aurora"
  engine                              =  local.db_engine
  engine_version                      =  local.db_engine_version
  #engine_mode                         =  local.db_engine_mode
  database_name                       =  local.database_name
  master_username                     =  local.master_username
  master_password                     =  random_password.master_password.result
  final_snapshot_identifier           =  local.snapshot_name
  skip_final_snapshot                 =  local.skip_final_snapshot
  backup_retention_period             =  local.backup_retention_period
  preferred_backup_window             =  local.backup_window
  preferred_maintenance_window        =  local.maintenance_window
  port                                =  local.db_port
  storage_encrypted                   =  local.storage_encrypted
  allow_major_version_upgrade         =  local.allow_major_version_upgrade
  enabled_cloudwatch_logs_exports     =  local.enabled_cloudwatch_logs_exports
  deletion_protection                 =  local.deletion_protection
  db_subnet_group_name                =  aws_db_subnet_group.subnet_group.name
  vpc_security_group_ids              =  [aws_security_group.rds.id]
  serverlessv2_scaling_configuration {
    max_capacity =  local.max_capacity
    min_capacity =  local.min_capacity
  }

  #tags = merge(
  #  {
  #    "Name" = local.cluster_name
  #  },
  #  var.tags,
  #)

}

resource "aws_rds_cluster_instance" "instance" {
  cluster_identifier = aws_rds_cluster.rds.cluster_identifier
  instance_class     = local.db_instance_class
  engine             = aws_rds_cluster.rds.engine
  engine_version     = aws_rds_cluster.rds.engine_version

}

resource "random_password" "master_password" {
  length  = local.master_password_length
  special = false
  keepers = {
    Name =  local.master_username
  }
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = "${var.app}-rds-aurora-subnet-group"
  subnet_ids = var.db_subnet_ids
  
}

resource "random_id" "snapshot" {
  byte_length = 3
  keepers = {
    Name = var.app
  }
}