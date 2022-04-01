#define any tags appropriate to your environment
tags = {
  ManagedBy = "terraform"
  Project = "CTDC"
  Environment = "DEV2"
  POC = ""
}
#enter the region in which your aws resources will be provisioned
region = "us-east-1"

#specify the name you will like to call this project.
stack_name = "ctdc2"

#vpc_id = "< UPDATE >"
vpc_id = "vpc-08f154f94dc8a0e34"

#private_subnet_ids = ["< UPDATE >"]
private_subnet_ids = ["subnet-07d177a4d9df5cd32","subnet-09b0c7407416d4730"]

#public_subnet_ids = ["< UPDATE >"]
public_subnet_ids = ["subnet-0a575f7e0c97cad77","subnet-03bb1c845d35aacc5"]

#subnet_ip_block = ["< UPDATE >"]
subnet_ip_block = ["172.18.10.0/24"]

create_es_service_role = false

#alb_certificate_arn = "< UPDATE >"
alb_certificate_arn = "arn:aws:acm:us-east-1:420434175168:certificate/fae9c2de-f4b9-4e03-9d5e-589d2a5790fa"

create_alb_s3_bucket = true

#name of the ssh key imported in the deployment instruction
#ssh_key_name = ""
ssh_key_name = "devops"
#ssh_user = ""
ssh_user = "bento"