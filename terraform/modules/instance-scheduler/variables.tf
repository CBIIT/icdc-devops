
variable "stack_name" {
  type        = string
  description = "name of this stack"
  default     = "aws-instance-scheduler-test"
}
variable "scheduling_active" {
  description = "Activate or deactivate scheduling."
  type        = string
  default     =  "Yes"
}
variable "scheduled_services" {
  description = "Scheduled Services."
  type        = string
  default     = "EC2"
}
variable "schedule_rds_clusters" {
  description = "Enable scheduling of Aurora clusters for RDS Service."
  type        =  bool
  default     =  false
}
variable "create_rds_snapshot" {
  description = "Create snapshot before stopping RDS instances (does not apply to Aurora Clusters)."
  type        =  bool
  default     =  false
}
variable "memory_size" {
  description = "Size of the Lambda function running the scheduler, increase size when processing large numbers of instances."
  type        = string
//  default     = "128"
}
variable "use_cloud_watch_metrics" {
  description = "Collect instance scheduling data using CloudWatch metrics."
  type        =  bool
  default     =  false
}
variable "log_retention_days" {
  description = "Retention days for scheduler logs."
  type        = string
  default     = "30"
}
variable "trace" {
  description = "Enable logging of detailed information in CloudWatch logs."
  type        =  string
  default     =  "No"
}
variable "enable_ssm_maintenance_windows" {
  description = "Enable the solution to load SSM Maintenance Windows, so that they can be used for EC2 instance Scheduling."
  type        = string
  default     =  "No"
}
variable "tag_name" {
  description = "Name of tag to use for associating instance schedule schemas with service instances."
  type        = string
  default     = "Schedule"
}
variable "default_timezone" {
  description = "Choose the default Time Zone. Default is 'UTC'."
  type        = string
  default     = "UTC"
}
variable "regions" {
  description = "List of regions in which instances are scheduled, leave blank for current region only."
  type        =  list(string)
  default     =  ["us-east-1"]
}
variable "cross_account_roles" {
  description = "Comma separated list of ARN's for cross account access roles. These roles must be created in all checked accounts the scheduler to start and stop instances."
  type        = string
  default     = null
}
variable "started_tags" {
  description = "Comma separated list of tagname and values on the formt name=value,name=value,.. that are set on started instances"
  type        = string
  default     =  "Schedule=Enabled"
}
variable "stopped_tags" {
  description = "Comma separated list of tagname and values on the formt name=value,name=value,.. that are set on stopped instances"
  type        = string
  default     =  "Schedule=Enabled"
}
variable "scheduler_frequency" {
  description = "Scheduler running frequency in minutes."
  type        = string
  default     = "5"
}
variable "schedule_lambda_account" {
  description = "Schedule instances in this account."
  type        = string
  default     = "Yes"
}
variable "tags" {
  type = map(string)
  default = {
    Ticket = "CLDOPS-2311"
  }
}