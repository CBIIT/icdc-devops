#create database security group
resource "aws_security_group" "database-sg" {
  name = "${var.stack_name}-${terraform.workspace}-database-sg"
  description = "database security group"
  vpc_id = var.vpc_id
  tags = merge(
  {
    "Name" = format("%s-%s",var.stack_name,"database-sg")
  },
  var.tags,
  )
}

// Neo4j security rules
resource "aws_security_group_rule" "neo4j_http" {
  from_port = local.neo4j_http
  protocol = local.tcp_protocol
  to_port = local.neo4j_http
  cidr_blocks = var.subnet_ip_block
  security_group_id = aws_security_group.database-sg.id
  type = "ingress"
}
resource "aws_security_group_rule" "neo4j_https" {
  from_port = local.neo4j_https
  protocol = local.tcp_protocol
  to_port = local.neo4j_https
  cidr_blocks = var.subnet_ip_block
  security_group_id = aws_security_group.database-sg.id
  type = "ingress"
}
resource "aws_security_group_rule" "neo4j_bolt" {
  from_port = local.neo4j_bolt
  protocol = local.tcp_protocol
  to_port = local.neo4j_bolt
  cidr_blocks = var.subnet_ip_block
  security_group_id = aws_security_group.database-sg.id
  type = "ingress"
}

// Outbound security rules
resource "aws_security_group_rule" "all_outbound" {
  from_port = local.any_port
  protocol = local.any_protocol
  to_port = local.any_port
  cidr_blocks = local.all_ips
  security_group_id = aws_security_group.database-sg.id
  type = "egress"
}

//Dataloader security rules
//resource "aws_security_group_rule" "dataloader_http" {
//  from_port = local.neo4j_http
//  protocol = local.tcp_protocol
//  to_port = local.neo4j_http
//  source_security_group_id = data.terraform_remote_state.bastion.outputs.bastion_security_group_id
//  security_group_id = aws_security_group.database-sg.id
//  type = "ingress"
//}
//resource "aws_security_group_rule" "dataloader_bolt" {
//  from_port = local.neo4j_bolt
//  protocol = local.tcp_protocol
//  to_port = local.neo4j_bolt
//  source_security_group_id = data.terraform_remote_state.bastion.outputs.bastion_security_group_id
//  security_group_id = aws_security_group.database-sg.id
//  type = "ingress"
//}

// SSH security rules
//resource "aws_security_group_rule" "bastion_host_ssh" {
//  from_port = local.bastion_port
//  protocol = local.tcp_protocol
//  to_port = local.bastion_port
//  source_security_group_id = data.terraform_remote_state.bastion.outputs.bastion_security_group_id
//  security_group_id = aws_security_group.database-sg.id
//  type = "ingress"
//}

// Katalon security rules
//resource "aws_security_group_rule" "katalon_bolt" {
//  from_port = local.neo4j_bolt
//  protocol = local.tcp_protocol
//  to_port = local.neo4j_bolt
//  source_security_group_id = data.terraform_remote_state.bastion.outputs.katalon-sg-id
//  security_group_id = aws_security_group.database-sg.id
//  type = "ingress"
//}
//resource "aws_security_group_rule" "katalon_http" {
//  from_port = local.neo4j_http
//  protocol = local.tcp_protocol
//  to_port = local.neo4j_http
//  source_security_group_id = data.terraform_remote_state.bastion.outputs.katalon-sg-id
//  security_group_id = aws_security_group.database-sg.id
//  type = "ingress"
//}