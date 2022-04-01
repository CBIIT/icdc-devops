# create s3 bucket for alb logs
resource "aws_s3_bucket" "alb_logs_bucket" {
  count = var.create_alb_s3_bucket ? 1 : 0

  bucket = local.alb_s3_bucket_name

  tags = merge(
    {
      "Name" = local.alb_s3_bucket_name
    },
    var.tags,
  )
}

resource "aws_s3_bucket_acl" "this" {
  count = var.create_alb_s3_bucket ? 1 : 0
  
  bucket = aws_s3_bucket.alb_logs_bucket[count.index].id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count = var.create_alb_s3_bucket ? 1: 0
  
  bucket = aws_s3_bucket.alb_logs_bucket[count.index].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count = var.create_alb_s3_bucket ? 1 : 0
  
  bucket = aws_s3_bucket.alb_logs_bucket[count.index].id

  rule {
    id = "transition_to_standard_ia"
    status = "Enabled"
    
	transition {
      days = var.s3_object_standard_ia_transition_days
	  storage_class = "STANDARD_IA"
    }
    
	noncurrent_version_transition {
      noncurrent_days = var.s3_object_nonactive_expiration_days - 30 > 30 ? 30 : var.s3_object_nonactive_expiration_days + 30
      storage_class = "STANDARD_IA"
    }
	
  }
  
  rule {
    id = "expire_objects"
    status = "Enabled"
    
	expiration {
      days = var.s3_object_expiration_days
    }
    
	noncurrent_version_expiration {
      noncurrent_days = var.s3_object_nonactive_expiration_days
    }
	
  }
}