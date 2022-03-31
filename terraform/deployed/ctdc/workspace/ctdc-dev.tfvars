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

private_subnet_ids = ["< UPDATE >"]

vpc_id = "< UPDATE >"

subnet_ip_block = ["< UPDATE >"]

create_es_service_role = false
