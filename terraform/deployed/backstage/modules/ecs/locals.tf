locals {
  cluster_name = "${var.app}-${terraform.workspace}-ecs-cluster"

  http_port    = 80
  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  https_port   = "443"
  all_ips      = ["0.0.0.0/0"]
}

locals {
  iam_prefix = "poweruser"
  permission_boundary_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/PermissionBoundary_PowerUser"
}
