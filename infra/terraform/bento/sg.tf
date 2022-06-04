#create alb security group
resource "aws_security_group" "alb-sg" {
  name   = "${var.stack_name}-${var.env}-alb-sg"
  vpc_id = var.vpc_id
  tags = merge(
  {
    "Name" = format("%s-%s-alb-sg", var.stack_name, var.env)
  },
  var.tags,
  )
}

resource "aws_security_group_rule" "inbound_http" {
  from_port   = local.http_port
  protocol    = local.tcp_protocol
  to_port     = local.http_port
  cidr_blocks = var.alb_allowed_ip_range
  security_group_id = aws_security_group.alb-sg.id
  type              = "ingress"
}

resource "aws_security_group_rule" "inbound_https" {
  from_port   = local.https_port
  protocol    = local.tcp_protocol
  to_port     = local.https_port
  cidr_blocks = var.alb_allowed_ip_range
  security_group_id = aws_security_group.alb-sg.id
  type              = "ingress"
}

resource "aws_security_group_rule" "all_outbound" {
  from_port   = local.any_port
  protocol    = local.any_protocol
  to_port     = local.any_port
  cidr_blocks = local.all_ips
  security_group_id = aws_security_group.alb-sg.id
  type              = "egress"
}