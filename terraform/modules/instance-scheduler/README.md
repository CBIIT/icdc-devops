## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.scheduler_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_rule.tag_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.scheduler_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_event_target.tag_instance_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.scheduler_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_dynamodb_table.config_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_dynamodb_table.maintenance_window_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_dynamodb_table.state_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_dynamodb_table_item.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table_item) | resource |
| [aws_dynamodb_table_item.period](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table_item) | resource |
| [aws_dynamodb_table_item.running](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table_item) | resource |
| [aws_dynamodb_table_item.schedule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table_item) | resource |
| [aws_dynamodb_table_item.stopped](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table_item) | resource |
| [aws_iam_policy.ec2_dynamo_db_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ec2_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.scheduler_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.scheduler_rds_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.scheduler_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.scheduler_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.attach_policy_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ec2_dynamo_db_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ec2_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.scheduler_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.scheduler_rds_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.scheduler_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.instance_scheduler_encryption_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.instance_scheduler_encryption_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.tag_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.invoke_lambda_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.invoke_lambda_permission_tag_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_sns_topic.instance_scheduler_sns_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [archive_file.instance_tag](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.dynamo_db_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ec2_permission_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.encryption_key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_role_assume_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.rds_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.scheduler_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.scheduler_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_rds_snapshot"></a> [create\_rds\_snapshot](#input\_create\_rds\_snapshot) | Create snapshot before stopping RDS instances (does not apply to Aurora Clusters). | `bool` | `false` | no |
| <a name="input_cross_account_roles"></a> [cross\_account\_roles](#input\_cross\_account\_roles) | Comma separated list of ARN's for cross account access roles. These roles must be created in all checked accounts the scheduler to start and stop instances. | `string` | `null` | no |
| <a name="input_default_timezone"></a> [default\_timezone](#input\_default\_timezone) | Choose the default Time Zone. Default is 'UTC'. | `string` | `"UTC"` | no |
| <a name="input_enable_ssm_maintenance_windows"></a> [enable\_ssm\_maintenance\_windows](#input\_enable\_ssm\_maintenance\_windows) | Enable the solution to load SSM Maintenance Windows, so that they can be used for EC2 instance Scheduling. | `string` | `"No"` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | Retention days for scheduler logs. | `string` | `"30"` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Size of the Lambda function running the scheduler, increase size when processing large numbers of instances. | `string` | `"128"` | no |
| <a name="input_regions"></a> [regions](#input\_regions) | List of regions in which instances are scheduled, leave blank for current region only. | `list(string)` | <pre>[<br>  "us-east-1"<br>]</pre> | no |
| <a name="input_schedule_lambda_account"></a> [schedule\_lambda\_account](#input\_schedule\_lambda\_account) | Schedule instances in this account. | `string` | `"Yes"` | no |
| <a name="input_schedule_rds_clusters"></a> [schedule\_rds\_clusters](#input\_schedule\_rds\_clusters) | Enable scheduling of Aurora clusters for RDS Service. | `bool` | `false` | no |
| <a name="input_scheduled_services"></a> [scheduled\_services](#input\_scheduled\_services) | Scheduled Services. | `string` | `"EC2"` | no |
| <a name="input_scheduler_frequency"></a> [scheduler\_frequency](#input\_scheduler\_frequency) | Scheduler running frequency in minutes. | `string` | `"5"` | no |
| <a name="input_scheduling_active"></a> [scheduling\_active](#input\_scheduling\_active) | Activate or deactivate scheduling. | `string` | `"Yes"` | no |
| <a name="input_stack_name"></a> [stack\_name](#input\_stack\_name) | name of this stack | `string` | `"aws-instance-scheduler-test"` | no |
| <a name="input_started_tags"></a> [started\_tags](#input\_started\_tags) | Comma separated list of tagname and values on the formt name=value,name=value,.. that are set on started instances | `string` | `"Schedule=Enabled"` | no |
| <a name="input_stopped_tags"></a> [stopped\_tags](#input\_stopped\_tags) | Comma separated list of tagname and values on the formt name=value,name=value,.. that are set on stopped instances | `string` | `"Schedule=Enabled"` | no |
| <a name="input_tag_name"></a> [tag\_name](#input\_tag\_name) | Name of tag to use for associating instance schedule schemas with service instances. | `string` | `"Schedule"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | <pre>{<br>  "Ticket": "CLDOPS-2311"<br>}</pre> | no |
| <a name="input_trace"></a> [trace](#input\_trace) | Enable logging of detailed information in CloudWatch logs. | `string` | `"No"` | no |
| <a name="input_use_cloud_watch_metrics"></a> [use\_cloud\_watch\_metrics](#input\_use\_cloud\_watch\_metrics) | Collect instance scheduling data using CloudWatch metrics. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_id"></a> [account\_id](#output\_account\_id) | Account to give access to when creating cross-account access role for cross account scenario |
| <a name="output_configuration_table"></a> [configuration\_table](#output\_configuration\_table) | Name of the DynamoDB configuration table |
| <a name="output_issue_sns_topic_arn"></a> [issue\_sns\_topic\_arn](#output\_issue\_sns\_topic\_arn) | Topic to subscribe to for notifications of errors and warnings |
| <a name="output_scheduler_role_arn"></a> [scheduler\_role\_arn](#output\_scheduler\_role\_arn) | Role for the instance scheduler lambda function |
| <a name="output_service_instance_schedule_service_token"></a> [service\_instance\_schedule\_service\_token](#output\_service\_instance\_schedule\_service\_token) | Arn to use as ServiceToken property for custom resource type Custom::ServiceInstanceSchedule |
