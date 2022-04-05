data "aws_caller_identity" "current" {}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}


data "aws_acm_certificate" "cert" {
  domain      = var.certificate_domain_name
  types       = [local.cert_types]
  most_recent = true
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    sid = "allowalbaccount"
    effect = "Allow"
    principals {
      identifiers = ["arn:aws:iam::${lookup(var.aws_account_id,var.region,"us-east-1" )}:root"]
      type        = "AWS"
    }
    actions = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${local.alb_s3_bucket_name}/*"]
  }
  statement {
    sid = "allowalblogdelivery"
    effect = "Allow"
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
    actions = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${local.alb_s3_bucket_name}/*"]
    condition {
      test     = "StringEquals"
      values   = ["bucket-owner-full-control"]
      variable = "s3:x-amz-acl"
    }
  }
  statement {
    sid = "awslogdeliveryacl"
    effect = "Allow"
    actions = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::${local.alb_s3_bucket_name}"]
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "ecr_policy_doc" {

  statement {
    sid    = "ElasticContainerRegistryPushAndPull"
    effect = "Allow"

    principals {
      identifiers = [local.account_arn]
      type        = "AWS"
    }
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
    ]
  }
}

data "aws_iam_policy_document" "task_execution_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect = "Allow"
    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
  }
}


data "aws_iam_policy_document" "task_logs_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}

data "aws_iam_policy_document" "ecs_policy_doc" {
  statement {
    effect = "Allow"
    actions = ["ecs:*"]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ecr:*"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ssm:*"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "es:*"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "elasticache:*"
    ]
    resources = ["*"]
  }

}