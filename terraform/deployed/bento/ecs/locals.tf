locals {
  alb_s3_bucket_name = "${var.stack_name}-alb-${terraform.workspace}-access-logs"
  http_port    = 80
  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  https_port   = "443"
  all_ips      = ["0.0.0.0/0"]
  account_arn = format("arn:aws:iam::%s:root", data.aws_caller_identity.current.account_id)
  app_url = "${var.app_sub_domain}.${var.domain_name}"
}
