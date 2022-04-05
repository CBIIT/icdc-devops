#define any tags appropriate to your environment
tags = {
  ManagedBy = "terraform"
  Project = "CTDC"
  Environment = "DEV"
  POC = ""
}
#enter the region in which your aws resources will be provisioned
region = "us-east-1"

#specify the name you will like to call this project.
stack_name = "ctdc"

vpc_id = "< UPDATE >"

private_subnet_ids = ["< UPDATE >"]

public_subnet_ids = ["< UPDATE >"]

subnet_ip_block = ["< UPDATE >"]

db_private_ip = "< UPDATE >"

create_es_service_role = false

alb_certificate_arn = "< UPDATE >"

create_alb_s3_bucket = true

#name of the ssh key imported in the deployment instruction
ssh_key_name = "< UPDATE >"
ssh_user = "< UPDATE >"
