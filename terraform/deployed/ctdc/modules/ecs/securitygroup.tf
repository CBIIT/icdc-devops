resource "aws_security_group" "app_sg" {
  name = "${var.stack_name}-${terraform.workspace}-app-sg"
  vpc_id = var.vpc_id
  tags = merge(
  {
    "Name" = format("%s-%s-frontend-sg",var.stack_name,terraform.workspace),
  },
  var.tags,
  )
}

resource "aws_security_group_rule" "inbound_frontend_alb" {
  from_port = var.frontend_container_port
  protocol = local.tcp_protocol
  to_port = var.frontend_container_port
  security_group_id = aws_security_group.app_sg.id
  source_security_group_id = var.alb_sg_id
  type = "ingress"
}

resource "aws_security_group_rule" "inbound_backend_alb" {
  from_port = var.backend_container_port
  protocol = local.tcp_protocol
  to_port = var.backend_container_port
  security_group_id = aws_security_group.app_sg.id
  source_security_group_id = var.alb_sg_id
  type = "ingress"
}

resource "aws_security_group_rule" "all_outbound_frontend" {
  from_port = local.any_port
  protocol = local.any_protocol
  to_port = local.any_port
  cidr_blocks = local.all_ips
  security_group_id = aws_security_group.app_sg.id
  type = "egress"
}
