
resource "aws_s3_bucket" "metric" {
  bucket = "${var.program}-${local.level}-${var.stack_name}-failed-metric-delivery"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = var.tags
}
resource "aws_s3_bucket_public_access_block" "metric" {
  bucket = aws_s3_bucket.metric.id
  block_public_acls = true
  block_public_policy = true
  restrict_public_buckets = true
  ignore_public_acls = true
}

module "new_relic_metric_pipeline" {
   source = "github.com/CBIIT/datacommons-devops/terraform/modules/firehose-metrics/"
   count  =  var.enable_metric_pipeline && terraform.workspace == "dev" ||  var.enable_metric_pipeline && terraform.workspace == "stage" ? 1 : 0
   account_id                = data.aws_caller_identity.current.account_id
   app                       = var.project_name
   http_endpoint_access_key  = var.http_endpoint_access_key
   level                     = local.level
   new_relic_account_id      = var.new_relic_account_id
   permission_boundary_arn   = local.permissions_boundary
   program                   = var.program #i.e. "crdc"
   s3_bucket_arn             = aws_s3_bucket.metric.arn
}