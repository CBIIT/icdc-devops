
#create security group
resource "aws_instance" "ot_frontend" {
  ami          =  data.aws_ssm_parameter.ecs_optimized.value
  instance_type     =  var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ec2-instance-profile.name
  vpc_security_group_ids   = [aws_security_group.ot_frontend_security_group.id]
  subnet_id  = data.terraform_remote_state.network.outputs.private_subnets_ids[0]
  key_name    =  var.ssh_key_name
  user_data   =  data.template_cloudinit_config.user_data.rendered
  tags = merge(
  {
    Name        = "${var.program}-${var.app}-frontend-${var.env}"
  },
  var.tags,
  )
}

resource "aws_security_group" "ot_frontend_security_group" {
  name = "${var.program}-${var.app}-frontend-${var.env}-sg"
  description = "ot-frontend security group"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
  tags = merge(
  {
    "Name" = format("%s-%s",var.app,"ot-frontend-sg")
  },
  var.tags,
  )
}

resource "aws_security_group_rule" "ot_frontend_bastion_host_ssh" {
  from_port = local.bastion_port
  protocol = local.tcp_protocol
  to_port = local.bastion_port
  source_security_group_id = data.terraform_remote_state.bastion.outputs.bastion_security_group_id
  security_group_id = aws_security_group.ot_frontend_security_group.id
  type = "ingress"
}

resource "aws_security_group_rule" "ot_frontend_inbound_alb_http" {
  from_port = local.http_port
  protocol = local.tcp_protocol
  to_port = local.http_port
  security_group_id = aws_security_group.ot_frontend_security_group.id
  source_security_group_id = module.alb.alb_security_group_id
  type = "ingress"
}

resource "aws_security_group_rule" "ot_frontend_inbound_alb_https" {
  from_port = local.https_port
  protocol = local.tcp_protocol
  to_port = local.https_port
  security_group_id = aws_security_group.ot_frontend_security_group.id
  source_security_group_id = module.alb.alb_security_group_id
  type = "ingress"
  #cidr_blocks = [local.vpc_cidr_block]
}

resource "aws_security_group_rule" "ot_frontend_all_outbound" {
  from_port = local.any_port
  protocol = local.any_protocol
  to_port = local.any_port
  cidr_blocks = local.all_ips
  security_group_id = aws_security_group.ot_frontend_security_group.id
  type = "egress"
}

#create alb target group
resource "aws_lb_target_group" "ot_frontend_target_group" {
  name = "${var.program}-${var.app}-frontend-${var.env}-tg"
  port = local.custom_port
  protocol = "HTTP"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
  stickiness {
    type = "lb_cookie"
    cookie_duration = 1800
    enabled = true
  }
  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
  tags = merge(
  {
    "Name" = format("%s-%s-%s",var.app,var.env,"frontend-alb-target")
  },
  var.tags,
  )
}

resource "aws_lb_listener_rule" "ot_frontend_alb_listener" {
  listener_arn = module.alb.alb_https_listener_arn
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.ot_frontend_target_group.arn
  }

  condition {
    host_header {
      values = ["${var.program}-${var.app}-${var.env}.${var.domain_name}"]
    }
  }
  condition {
    path_pattern  {
      values = ["/*"]
    }
  }

}

resource "aws_lb_target_group_attachment" "ot_frontend" {
  target_group_arn = aws_lb_target_group.ot_frontend_target_group.arn
  target_id = aws_instance.ot_frontend.id
  port      = local.custom_port
}


#create boostrap script to hook up the node to ecs cluster
resource "aws_ssm_document" "ot_frontend_boostrap" {
  name          = "${var.program}-${var.app}-initialize-frontend-${var.env}"
  document_type = "Command"
  document_format = "YAML"
  content = <<DOC
---
schemaVersion: '2.2'
description: State Manager Bootstrap Example
parameters: {}
mainSteps:
- action: aws:runShellScript
  name: configureServer
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
    - ansible-playbook docker.yml
DOC
  tags = merge(
  {
    "Name" = format("%s-%s",var.app,"ssm-document")
  },
  var.tags,
  )
}

resource "aws_ssm_association" "ppdc_frontend_ssm" {
  name = aws_ssm_document.ot_frontend_boostrap.name
  targets {
    key   = "tag:Name"
    values = ["${var.program}-${var.app}-frontend-${var.env}"]
  }
}

data "aws_route53_zone" "ppdc_frontend_zone" {
  name  = var.domain_name
}

resource "aws_route53_record" "ppdc_frontend_records" {
  name = "${var.program}-${var.app}-${var.env}"
  type = "A"
  zone_id = data.aws_route53_zone.zone.zone_id
  alias {
    evaluate_target_health = false
    name = module.alb.alb_dns_name
    zone_id = module.alb.alb_zone_id
  }
}

resource "aws_route53_record" "ppdc_api_record" {
  name = "${var.program}-${var.app}-${var.env}-api"
  type = "A"
  zone_id = data.aws_route53_zone.zone.zone_id
  alias {
    evaluate_target_health = false
    name = module.alb.alb_dns_name
    zone_id = module.alb.alb_zone_id
  }
}