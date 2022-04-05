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
}


