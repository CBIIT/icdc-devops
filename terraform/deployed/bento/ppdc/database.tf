resource "aws_instance" "db" {
  ami = data.aws_ami.centos.id
  instance_type = var.database_instance_type
  key_name = var.ssh_key_name
  subnet_id                = data.terraform_remote_state.network.outputs.private_subnets_ids[1]
  iam_instance_profile = aws_iam_instance_profile.ecs-instance-profile.id
  source_dest_check           = false
  ebs_optimized = true
  vpc_security_group_ids = [aws_security_group.ppdc-database-sg.id]
  user_data  = data.template_cloudinit_config.user_data.rendered
  root_block_device {
    volume_type   = var.evs_volume_type
    volume_size   = var.db_instance_volume_size
    delete_on_termination = true
  }
  tags = merge(
  {
    "Name" = "${var.stack_name}-${var.frontend_app_name}-frontend-${var.env}-database",
  },
  var.tags,
  )
}

#create database security group
resource "aws_security_group" "ppdc-database-sg" {
  name = "${var.stack_name}-${var.frontend_app_name}-frontend-${var.env}-database-sg"
  description = "database security group"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
  tags = merge(
  {
    "Name" = format("%s-%s-%s-%s-%s",var.stack_name,var.frontend_app_name,"frontend",var.env,"database-sg")
  },
  var.tags,
  )
}


resource "aws_security_group_rule" "bastion_host_ssh" {
  from_port = local.bastion_port
  protocol = local.tcp_protocol
  to_port = local.bastion_port
  source_security_group_id = data.terraform_remote_state.bastion.outputs.bastion_security_group_id
  security_group_id = aws_security_group.ppdc-database-sg.id
  type = "ingress"
}

resource "aws_security_group_rule" "ppdc_allow_backend" {
  from_port = local.backend_port
  protocol = local.tcp_protocol
  to_port = local.backend_port
  #source_security_group_id = aws_security_group.ppdc-database-sg.id
  security_group_id = aws_security_group.ppdc-database-sg.id
  cidr_blocks = [local.vpc_cidr_block]
  type = "ingress"
}

resource "aws_security_group_rule" "ppdc_allow_backend1" {
  from_port = local.backend_port1
  protocol = local.tcp_protocol
  to_port = local.backend_port1
  #source_security_group_id = aws_security_group.ppdc-database-sg.id
  security_group_id = aws_security_group.ppdc-database-sg.id
  cidr_blocks = [local.vpc_cidr_block]
  type = "ingress"
}

resource "aws_security_group_rule" "all_outbound" {
  from_port = local.any_port
  protocol = local.any_protocol
  to_port = local.any_port
  cidr_blocks = local.all_ips
  security_group_id = aws_security_group.ppdc-database-sg.id
  type = "egress"
}


#create boostrap script to hook up the node to ecs cluster
resource "aws_ssm_document" "ssm_ppdc_database_boostrap" {
#resource "aws_ssm_document" "ssm_neo4j_boostrap" {
  name          = "${var.stack_name}-${var.frontend_app_name}-frontend-${var.env}-setup-database"
  document_type = "Command"
  document_format = "YAML"
  content = <<DOC
---
schemaVersion: '2.2'
description: Bootstrap instance with Clickhouse
parameters: {}
mainSteps:
- action: aws:runShellScript
  name: configureDatabase
  inputs:
    runCommand:
    - set -ex
    - cd /tmp
    - rm -rf icdc-devops || true
    - yum -y install epel-release
    - yum -y install wget git python-setuptools python-pip
    - pip install --upgrade "pip < 21.0"
    - pip install ansible==2.8.0 boto boto3 botocore
    - git clone https://github.com/CBIIT/icdc-devops
    - cd icdc-devops/ansible && git checkout master
    - ansible-playbook open-target-database.yml

DOC
  tags = merge(
  {
    "Name" = format("%s-%s",var.stack_name,"ssm-document")
  },
  var.tags,
  )
}


resource "aws_ssm_association" "database" {
  name = aws_ssm_document.ssm_ppdc_database_boostrap.name
  targets {
    key    = "tag:Name"
    values = ["${var.stack_name}-${var.frontend_app_name}-frontend-${var.env}-database"]
  }
  depends_on = [aws_instance.db]
}
