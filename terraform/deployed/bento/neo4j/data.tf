#define user data
data "template_cloudinit_config" "user_data" {
  gzip          = false
  base64_encode = false
  part {
    content = <<EOF
#cloud-config
---
users:
  - name: "${local.ssh_user}"
    gecos: "${local.ssh_user}"
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: wheel
    shell: /bin/bash
    ssh_authorized_keys:
    - "${data.aws_ssm_parameter.sshkey.value}"
EOF
  }

  part {
    content_type = "text/x-shellscript"
    content      = file("ssm.sh")
  }
}

#collect details from bastion
data "terraform_remote_state" "bastion" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket_name
    key = "bento/management/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}
data "aws_ssm_parameter" "amz_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#grab public ssh key
data "aws_ssm_parameter" "sshkey" {
  name = "ssh_public_key"
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

data "aws_iam_instance_profile" "db" {
  name = "bento-dev-ecs-instance-profile"
}