#!/bin/bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
mkdir workspace || true
cd workspace
git clone https://github.com/CBIIT/icdc-devops.git
cd icdc-devops && git checkout master
cd infra/terraform/bento

###########
terraform init -reconfigure -backend-config=workspace/cds/cds-prod.tfbackend
terraform workspace select stage
terraform plan -var-file=workspace/cds/cds-stage.tfvars

terraform workspace new stage
