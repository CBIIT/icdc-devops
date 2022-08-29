
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_partition" "current" {}


locals {
  mappings = {
    mappings = {
      TrueFalse = {
        Yes = "True"
        No  = "False"
      }
      EnabledDisabled = {
        Yes = "ENABLED"
        No  = "DISABLED"
      }
      Services = {
        EC2  = "ec2"
        RDS  = "rds"
        Both = "ec2,rds"
      }
      Timeouts = {
        1  = "cron(0/1 * * * ? *)"
        2  = "cron(0/2 * * * ? *)"
        5  = "cron(0/5 * * * ? *)"
        10 = "cron(0/10 * * * ? *)"
        15 = "cron(0/15 * * * ? *)"
        30 = "cron(0/30 * * * ? *)"
        60 = "cron(0 0/1 * * ? *)"
      }
      Settings = {
        MetricsUrl        = "https://metrics.awssolutionsbuilder.com/generic"
        MetricsSolutionId = "S00030"
      }
    }
    Send = {
      AnonymousUsage = {
        Data = "Yes"
      }
      ParameterKey = {
        UniqueId = "/Solutions/aws-instance-scheduler/UUID/"
      }
    }
  }
}


resource "aws_cloudwatch_log_group" "scheduler_log_group" {
  name = join("-", [var.stack_name, "logs"])
  retention_in_days = var.log_retention_days
  tags = var.tags
}

resource "aws_iam_role" "scheduler_role" {
  name = join("-", [var.stack_name, "scheduler-role"])
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  path = "/"
}

resource "aws_iam_role_policy_attachment" "attach_policy_lambda_role" {
  role =  aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_iam_policy" "scheduler_role_policy" {
  policy = data.aws_iam_policy_document.scheduler_role_policy.json
  name = join("", [var.stack_name, "scheduler-role-policy"])
}

resource "aws_iam_policy" "lambda_policy" {
  policy = data.aws_iam_policy_document.lambda_policy.json
  name = join("", [var.stack_name, "lambda-execution-policy"])
}

resource "aws_kms_key" "instance_scheduler_encryption_key" {
  policy = data.aws_iam_policy_document.encryption_key_policy.json
  description         = "Key for SNS"
  is_enabled          = true
  enable_key_rotation = true
}

resource "aws_kms_alias" "instance_scheduler_encryption_key_alias" {
  name          = join("", ["alias/", var.stack_name, "-instance-scheduler-encryption-key"])
  target_key_id = aws_kms_key.instance_scheduler_encryption_key.arn
}

resource "aws_sns_topic" "instance_scheduler_sns_topic" {
  kms_master_key_id = aws_kms_key.instance_scheduler_encryption_key.arn
}

resource "aws_iam_role" "lambda_role" {
  assume_role_policy = data.aws_iam_policy_document.lambda_role_assume_policy.json
  force_detach_policies =  true
}

resource "aws_lambda_function" "main" {
  s3_bucket   = join("", ["solutions-", data.aws_region.current.name])
  s3_key      = "aws-instance-scheduler/v1.4.1/instance-scheduler.zip"
  role        = aws_iam_role.scheduler_role.arn
  description = "EC2 and RDS instance scheduler, version v1.4.1"
  environment {
    variables = {
      SCHEDULER_FREQUENCY            = var.scheduler_frequency
      TAG_NAME                       = var.tag_name
      LOG_GROUP                      = aws_cloudwatch_log_group.scheduler_log_group.name
      ACCOUNT                        = data.aws_caller_identity.current.account_id
      ISSUES_TOPIC_ARN               = aws_sns_topic.instance_scheduler_sns_topic.id
      STACK_NAME                     = var.stack_name
      BOTO_RETRY                     = "5,10,30,0.25"
      ENV_BOTO_RETRY_LOGGING         = "FALSE"
      SEND_METRICS                   = local.mappings["mappings"]["TrueFalse"][local.mappings["Send"]["AnonymousUsage"]["Data"]]
      SOLUTION_ID                    = local.mappings["mappings"]["Settings"]["MetricsSolutionId"]
      TRACE                          = local.mappings["mappings"]["TrueFalse"][var.trace]
      ENABLE_SSM_MAINTENANCE_WINDOWS = local.mappings["mappings"]["TrueFalse"][var.enable_ssm_maintenance_windows]
      USER_AGENT                     = join("", ["InstanceScheduler-", var.stack_name, "-v1.4.1"])
      USER_AGENT_EXTRA               = "AwsSolution/SO0030/v1.4.1"
      METRICS_URL                    = local.mappings["mappings"]["Settings"]["MetricsUrl"]
      UUID_KEY                       = local.mappings["Send"]["ParameterKey"]["UniqueId"]
      START_EC2_BATCH_SIZE           = "5"
      DDB_TABLE_NAME                 = aws_dynamodb_table.state_table.name
      CONFIG_TABLE                   = aws_dynamodb_table.config_table.name
      MAINTENANCE_WINDOW_TABLE       = aws_dynamodb_table.maintenance_window_table.name
      STATE_TABLE                    = aws_dynamodb_table.state_table.name
    }
  }
  function_name = join("-", [var.stack_name, "instance-scheduler"])
  handler       = "main.lambda_handler"
  memory_size   = var.memory_size
  runtime       = "python3.7"
  timeout       = "300"
  tracing_config  {
    mode = "Active"
  }
}

resource "aws_lambda_permission" "invoke_lambda_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.main.arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scheduler_rule.arn
}

resource "aws_dynamodb_table" "state_table" {
  attribute {
    name = "service"
    type = "S"
  }
  attribute {
    name = "account-region"
    type = "S"
  }
  billing_mode = "PAY_PER_REQUEST"
  point_in_time_recovery {
    enabled = false
  }
  hash_key  = "service"
  range_key = "account-region"
  name      = join("-", [var.stack_name, "state-table"])
  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.instance_scheduler_encryption_key.arn
  }
}


resource "aws_dynamodb_table" "config_table" {
  billing_mode = "PAY_PER_REQUEST"
  point_in_time_recovery {
    enabled = true
  }
  attribute {
    name = "type"
    type = "S"
  }
  attribute {
    name = "name"
    type = "S"
  }
  hash_key  = "type"
  range_key = "name"
  name      = join("-", [var.stack_name, "config-table"])
  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.instance_scheduler_encryption_key.arn
  }
}

resource "aws_dynamodb_table" "maintenance_window_table" {
  billing_mode = "PAY_PER_REQUEST"
  point_in_time_recovery  {
    enabled                    = true
  }
  attribute {
    name = "Name"
    type = "S"
  }
  attribute {
    name = "account-region"
    type = "S"
  }
  hash_key  = "Name"
  range_key = "account-region"
  name      = join("-", [var.stack_name, "maintenance-window-table"])
  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.instance_scheduler_encryption_key.arn
  }
}

resource "aws_cloudwatch_event_rule" "scheduler_rule" {
  name = join("-",[var.stack_name,"scheduler_rule"])
  description         = "Instance Scheduler - Rule to trigger instance for scheduler function version v1.4.1"
  schedule_expression = local.mappings["mappings"]["Timeouts"][var.scheduler_frequency]
  is_enabled          = local.mappings["mappings"]["EnabledDisabled"][var.scheduling_active] == "ENABLED" ? true : false
}

resource "aws_cloudwatch_event_target" "scheduler_target" {
  rule      = aws_cloudwatch_event_rule.scheduler_rule.name
  target_id = "Target0"
  arn       = aws_lambda_function.main.arn
}

resource "aws_iam_policy" "ec2_permissions" {
  policy = data.aws_iam_policy_document.ec2_permission_policy.json
  name = join("-",[var.stack_name,"ec2-permissions"])

}

resource "aws_iam_policy" "ec2_dynamo_db_policy" {
  policy = data.aws_iam_policy_document.dynamo_db_policy.json
  name = join("-",[var.stack_name,"dynamo-db-policy"])
}

resource "aws_iam_policy" "scheduler_policy" {
  policy = data.aws_iam_policy_document.scheduler_policy.json
  name = join("-",[var.stack_name,"scheduler-policy"])
}

resource "aws_iam_policy" "scheduler_rds_policy" {
  policy = data.aws_iam_policy_document.rds_policy.json
  name = join("-",[var.stack_name,"rds-scheduler-policy"])
}

resource "aws_iam_role_policy_attachment" "ec2_permissions" {
  policy_arn = aws_iam_policy.ec2_permissions.arn
  role       = aws_iam_role.scheduler_role.name
}

resource "aws_iam_role_policy_attachment" "scheduler_role_policy" {
  policy_arn = aws_iam_policy.scheduler_role_policy.arn
  role       = aws_iam_role.scheduler_role.name
}
resource "aws_iam_role_policy_attachment" "scheduler_policy" {
  policy_arn = aws_iam_policy.scheduler_policy.arn
  role       = aws_iam_role.scheduler_role.name
}
resource "aws_iam_role_policy_attachment" "ec2_dynamo_db_policy" {
  policy_arn = aws_iam_policy.ec2_dynamo_db_policy.arn
  role       = aws_iam_role.scheduler_role.name
}
resource "aws_iam_role_policy_attachment" "scheduler_rds_policy" {
  policy_arn = aws_iam_policy.scheduler_rds_policy.arn
  role       = aws_iam_role.scheduler_role.name
}

resource "aws_dynamodb_table_item" "config" {
  hash_key   = aws_dynamodb_table.config_table.hash_key
  table_name = aws_dynamodb_table.config_table.name
  range_key =  aws_dynamodb_table.config_table.range_key
  item       = <<EOF
{
  "type": {
    "S": "config"
  },
  "name": {
    "S": "scheduler"
  },
  "create_rds_snapshot": {
    "BOOL": false
  },
  "default_timezone": {
    "S": "America/New_York"
  },
  "enable_SSM_maintenance_windows": {
    "BOOL": false
  },
  "regions": {
    "SS": [
      "us-east-1"
    ]
  },
  "scheduled_services": {
    "SS": [
      "ec2"
    ]
  },
  "schedule_clusters": {
    "BOOL": false
  },
  "schedule_lambda_account": {
    "BOOL": true
  },
  "tagname": {
    "S": "Schedule"
  },
  "trace": {
    "BOOL": false
  },
  "use_metrics": {
    "BOOL": false
  }
}
EOF
}

resource "aws_dynamodb_table_item" "period" {
  range_key   =  aws_dynamodb_table.config_table.range_key
  hash_key    =  aws_dynamodb_table.config_table.hash_key
  table_name  =  aws_dynamodb_table.config_table.name
  item        =<<EOF
{
  "type": {
    "S": "period"
  },
  "name": {
    "S": "office-hours-9-5"
  },
  "begintime": {
    "S": "21:20"
  },
  "description": {
    "S": "Office hours"
  },
  "endtime": {
    "S": "22:00"
  },
  "weekdays": {
    "SS": [
      "sat"
    ]
  }
}
EOF

}


resource "aws_dynamodb_table_item" "schedule" {
  range_key   =  aws_dynamodb_table.config_table.range_key
  hash_key    =  aws_dynamodb_table.config_table.hash_key
  table_name  =  aws_dynamodb_table.config_table.name
  item        =<<EOF
{
  "type": {
    "S": "schedule"
  },
  "name": {
    "S": "running"
  },
  "description": {
    "S": "Instances running"
  },
  "override_status": {
    "S": "running"
  },
  "use_metrics": {
    "BOOL": false
  }
}
EOF

}
resource "aws_dynamodb_table_item" "running" {
  range_key   =  aws_dynamodb_table.config_table.range_key
  hash_key    =  aws_dynamodb_table.config_table.hash_key
  table_name  =  aws_dynamodb_table.config_table.name
  item        = <<EOF
{
  "type": {
    "S": "schedule"
  },
  "name": {
    "S": "stopped"
  },
  "description": {
    "S": "Instances stopped"
  },
  "override_status": {
    "S": "stopped"
  },
  "use_metrics": {
    "BOOL": false
  }
}
EOF
}

resource "aws_dynamodb_table_item" "stopped" {
  range_key   =  aws_dynamodb_table.config_table.range_key
  hash_key    =  aws_dynamodb_table.config_table.hash_key
  table_name  =  aws_dynamodb_table.config_table.name
  item        = <<EOF
{
  "type": {
    "S": "schedule"
  },
  "name": {
    "S": "stopped"
  },
  "description": {
    "S": "Instances stopped"
  },
  "override_status": {
    "S": "stopped"
  },
  "use_metrics": {
    "BOOL": false
  }
}
EOF
}