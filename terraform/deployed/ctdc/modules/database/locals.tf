locals {
  http_port = 80
  any_port = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  https_port = "443"
  all_ips = ["0.0.0.0/0"]
  ssh_user = var.ssh_user
  neo4j_http = 7474
  neo4j_https = 7473
  neo4j_bolt = 7687
  permission_boundary_arn   = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/PermissionBoundary_PowerUser"
}


