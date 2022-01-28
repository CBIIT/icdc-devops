locals {
  alb_s3_bucket_name = "${var.stack_name}-alb-${terraform.workspace}-access-logs"
}
