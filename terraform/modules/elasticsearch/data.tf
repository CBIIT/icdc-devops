data "aws_region" "region" {}

data "aws_caller_identity" "caller" {}

data "aws_availability_zones" "az_zones" {
  state = "available"
}

#grab vpc and other details
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket_name
    key = "env/qa/bento/network/terraform.tfstate"
    region = var.region
    encrypt = true
  }
}