data "archive_file" "instance_tag" {
  type = "zip"
  source_dir  = "${path.module}/instance-tag"
  output_path = "${path.module}/instance-tag.zip"
}

resource "aws_lambda_function" "tag_instance" {
  filename = data.archive_file.instance_tag.output_path
  function_name = join("-", [var.stack_name, "tag-instance"])
  role = aws_iam_role.scheduler_role.arn
  handler = "main.handler"
  memory_size = 128
  timeout = 6
  source_code_hash = data.archive_file.instance_tag.output_base64sha256
  runtime = "python3.8"
  tags = var.tags
}

resource "aws_cloudwatch_event_rule" "tag_rule" {
  name = join("-",[var.stack_name,"tag-instance-rule"])
  description         = "Tag instances meant to be controlled by instance scheduler function version v1.4.1"
  schedule_expression = local.mappings["mappings"]["Timeouts"][var.scheduler_frequency]
  is_enabled          = local.mappings["mappings"]["EnabledDisabled"][var.scheduling_active] == "ENABLED" ? true : false
  tags = var.tags
}

resource "aws_cloudwatch_event_target" "tag_instance_target" {
  rule      = aws_cloudwatch_event_rule.tag_rule.name
  target_id = "Target0"
  arn       = aws_lambda_function.tag_instance.arn
}

resource "aws_lambda_permission" "invoke_lambda_permission_tag_instance" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tag_instance.arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.tag_rule.arn
}