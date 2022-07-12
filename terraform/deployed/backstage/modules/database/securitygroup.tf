resource "aws_security_group" "rds" {
  name  =  "${var.app}-rds-aurora-sg"
  vpc_id      = var.vpc_id
  description = "Allow traffic to/from RDS Aurora"
}

resource "aws_security_group_rule" "rds_inbound" {
  description = "From allowed SGs"
  type                     = "ingress"
  from_port                = local.db_port
  to_port                  = local.db_port
  protocol                 = local.protocol
  source_security_group_id = var.ecs_security_group_id
  #cidr_blocks              = var.allowed_ip_blocks
  security_group_id        = aws_security_group.rds.id
}

resource "aws_security_group_rule" "egress" {
  description       = "allow all outgoing traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = local.any
  cidr_blocks       = local.all_ips
  security_group_id =  aws_security_group.rds.id
}