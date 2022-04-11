#define any tags appropriate to your environment
tags = {
  ManagedBy = "terraform"
  Project = "CTDC"
  Environment = ""
  POC = ""
}
#enter the region in which your aws resources will be provisioned
region = ""

#specify the name you will like to call this project.
stack_name = ""

vpc_id = ""

private_subnet_ids = ""

public_subnet_ids = ""

subnet_ip_block = ""

db_private_ip = ""

create_es_service_role = false

alb_certificate_arn = ""

domain_url = ""

create_alb_s3_bucket = true

#name of the ssh key imported in the deployment instruction
ssh_key_name = ""
ssh_user = ""