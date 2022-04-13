locals {
  alb_s3_bucket_name = var.cloud_platform == "leidos" ? "${var.stack_name}-alb-${var.env}-access-logs" : "${var.stack_name}-${var.cloud_platform}-alb-${var.env}-access-logs"
  http_port    = 80
  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  https_port   = "443"
  all_ips      = ["0.0.0.0/0"]
  account_arn = format("arn:aws:iam::%s:root", data.aws_caller_identity.current.account_id)
  cert_types = var.cloud_platform == "leidos" ? "AMAZON_ISSUED" : "IMPORTED"
}
