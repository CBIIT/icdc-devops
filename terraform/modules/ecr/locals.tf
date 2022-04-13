locals {
  account_arn = format("arn:aws:iam::%s:root", data.aws_caller_identity.current.account_id)
}