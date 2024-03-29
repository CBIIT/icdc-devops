#define any tags appropriate to your environment
tags = {
  ManagedBy = "terraform"
  Project = "Bento"
  Environment = "prod"
  Region = "us-east-1"
}
#enter the region in which your aws resources will be provisioned
region = "us-east-1"

#specify your aws credential profile. Note this is not IAM role but rather profile configured during AWS CLI installation
profile = "bento"

#specify the name you will like to call this project.
stack_name = "bento"

#specify domain name
domain_name = "bento-tools.org"
#name of the application
app_name = "bento"

cloudfront_distribution_bucket_name = "bento-files"

env = "prod"

cloudfront_slack_channel_name = "bento-cloudfront-wafv2"
alarms = {
  error4xx = {
    name = "4xxErrorRate"
    threshold = 10
  }
  error5xx = {
    name = "5xxErrorRate"
    threshold = 10
  }
}
slack_secret_name = "cloudfront-slack"

