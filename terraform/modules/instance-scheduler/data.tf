data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect = "Allow"
    principals {
      identifiers = ["events.amazonaws.com", "lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "scheduler_role_policy" {
  statement {
    effect = "Allow"
    actions = ["xray:PutTraceSegments", "xray:PutTelemetryRecords"]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:GetRecords",
      "dynamodb:GetShardIterator",
      "dynamodb:Query",
      "dynamodb:GetItem",
      "dynamodb:Scan",
      "dynamodb:ConditionCheckItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem"
    ]
    resources = [aws_dynamodb_table.state_table.arn]
  }
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:BatchWriteItem"
    ]
    resources = [aws_dynamodb_table.config_table.arn, aws_dynamodb_table.maintenance_window_table.arn]
  }
  statement {
    effect = "Allow"
    actions = ["ssm:PutParameter", "ssm:GetParameter"]
    resources = ["arn:${data.aws_partition.current.partition}:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/Solutions/aws-instance-scheduler/UUID/*" ]
  }
}

data "aws_iam_policy_document" "encryption_key_policy" {
  statement {
    effect = "Allow"
    actions = [ "kms:*"]
    principals {
      identifiers = [join("", ["arn:", data.aws_partition.current.partition, ":iam::", data.aws_caller_identity.current.account_id, ":root"])]
      type        = "AWS"
    }
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = ["kms:GenerateDataKey*", "kms:Decrypt"]
    principals {
      identifiers = [aws_iam_role.scheduler_role.arn]
      type        = "AWS"
    }
    resources = ["*"]
    sid = "Allows use of key"
  }
  statement {
    effect = "Allow"
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
      "kms:GenerateDataKey",
      "kms:TagResource",
      "kms:UntagResource"
    ]
    principals {
      identifiers = [ join("", ["arn:", data.aws_partition.current.partition, ":iam::", data.aws_caller_identity.current.account_id, ":root"])]
      type        = "AWS"
    }
    resources = ["*"]
  }
}
data "aws_iam_policy_document" "lambda_role_assume_policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      join("", ["arn:", data.aws_partition.current.partition, ":logs:", data.aws_region.current.name, ":", data.aws_caller_identity.current.account_id, ":log-group:/aws/lambda/*"])
    ]
  }
}

data "aws_iam_policy_document" "ec2_permission_policy" {
  statement {
    effect = "Allow"
    actions = ["ec2:ModifyInstanceAttribute"]
    resources = ["arn:${data.aws_partition.current.partition}:ec2:*:${data.aws_caller_identity.current.account_id}:instance/*"]
  }
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    resources = ["arn:${data.aws_partition.current.partition}:iam::*:role/*EC2SchedulerCross*"]
  }
}

data "aws_iam_policy_document" "dynamo_db_policy" {
  statement {
     effect = "Allow"
    actions = ["ssm:GetParameter", "ssm:GetParameters"]
    resources = ["arn:${data.aws_partition.current.partition}:ssm:*:${data.aws_caller_identity.current.account_id}:parameter/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:DescribeLogStreams",
      "rds:DescribeDBClusters",
      "rds:DescribeDBInstances",
      "ec2:DescribeInstances",
      "ec2:DescribeRegions",
      "cloudwatch:PutMetricData",
      "ssm:DescribeMaintenanceWindows",
      "tag:GetResources"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutRetentionPolicy"
    ]
    resources = ["arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*", aws_cloudwatch_log_group.scheduler_log_group.arn]
  }
}

data "aws_iam_policy_document" "scheduler_policy" {
  statement {
    effect = "Allow"
    actions = [
      "rds:AddTagsToResource",
      "rds:RemoveTagsFromResource",
      "rds:DescribeDBSnapshots",
      "rds:StartDBInstance",
      "rds:StopDBInstance"
    ]
    resources = ["arn:${data.aws_partition.current.partition}:rds:*:${data.aws_caller_identity.current.account_id}:db:*"]
  }
  statement {
    effect = "Allow"
    actions = ["ec2:StartInstances", "ec2:StopInstances", "ec2:CreateTags", "ec2:DeleteTags"]
    resources = [ "arn:${data.aws_partition.current.partition}:ec2:*:${data.aws_caller_identity.current.account_id}:instance/*"]
  }
  statement {
    effect = "Allow"
    actions = ["sns:Publish"]
    resources = [aws_sns_topic.instance_scheduler_sns_topic.id]
  }
  statement {
    effect = "Allow"
    actions = ["lambda:InvokeFunction"]
    resources = ["arn:${data.aws_partition.current.partition}:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${var.stack_name}-InstanceSchedulerMain" ]
  }
  statement {
    effect = "Allow"
    actions = ["kms:GenerateDataKey*", "kms:Decrypt"]
    resources = [ aws_kms_key.instance_scheduler_encryption_key.arn]
  }
}
data "aws_iam_policy_document" "rds_policy" {
  statement {
    effect = "Allow"
    actions = ["rds:DeleteDBSnapshot", "rds:DescribeDBSnapshots", "rds:StopDBInstance"]
    resources = ["arn:${data.aws_partition.current.partition}:rds:*:${data.aws_caller_identity.current.account_id}:snapshot:*" ]
  }
  statement {
    effect = "Allow"
    actions = ["rds:AddTagsToResource", "rds:RemoveTagsFromResource", "rds:StartDBCluster", "rds:StopDBCluster"]
    resources = ["arn:${data.aws_partition.current.partition}:rds:*:${data.aws_caller_identity.current.account_id}:cluster:*"]
  }
}
