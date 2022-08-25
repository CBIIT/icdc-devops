output "account_id" {
  description = "Account to give access to when creating cross-account access role for cross account scenario "
  value       = data.aws_caller_identity.current.account_id
}
output "configuration_table" {
  description = "Name of the DynamoDB configuration table"
  value       = aws_dynamodb_table.config_table.arn
}
output "issue_sns_topic_arn" {
  description = "Topic to subscribe to for notifications of errors and warnings"
  value       = aws_sns_topic.instance_scheduler_sns_topic.id
}
output "scheduler_role_arn" {
  description = "Role for the instance scheduler lambda function"
  value       = aws_iam_role.scheduler_role.arn
}
output "service_instance_schedule_service_token" {
  description = "Arn to use as ServiceToken property for custom resource type Custom::ServiceInstanceSchedule"
  value       = aws_lambda_function.main.arn
}