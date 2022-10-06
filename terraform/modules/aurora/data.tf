data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_kms_alias" "kms" {
  name = "alias/aws/rds"
}