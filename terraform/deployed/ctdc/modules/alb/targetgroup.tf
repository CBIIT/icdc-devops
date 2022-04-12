#create alb target group
resource "aws_lb_target_group" "frontend_target_group" {
  name = "${var.stack_name}-${terraform.workspace}-frontend"
  port = var.frontend_container_port
  protocol = "HTTP"
  target_type = "ip"
  vpc_id =  var.vpc_id
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
    "Name" = format("%s-%s",var.stack_name,"frontend-alb-target-group")
  },
  var.tags,
  )
}

#create alb target group
resource "aws_lb_target_group" "backend_target_group" {
  name = "${var.stack_name}-${terraform.workspace}-backend"
  port = var.backend_container_port
  protocol = "HTTP"
  target_type = "ip"
  vpc_id =  var.vpc_id
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
    "Name" = format("%s-%s",var.stack_name,"backend-alb-target")
  },
  var.tags,
  )
}

resource "aws_lb_listener_rule" "frontend_alb_listener" {
  listener_arn = aws_lb_listener.listener_https.arn
  priority = var.fronted_rule_priority
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.frontend_target_group.arn
  }

  condition {
    host_header {
      values = ["${var.domain_url}"]
    }
  }
  condition {
    path_pattern  {
      values = ["/*"]
    }
  }

}

resource "aws_lb_listener_rule" "backend_alb_listener" {
  count =  terraform.workspace !=  "prod" ? 1:0
  listener_arn = aws_lb_listener.listener_https.arn
  priority = var.backend_rule_priority
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.backend_target_group.arn
  }

  condition {
    host_header {
      values = ["${var.domain_url}"]
    }

  }
  condition {
    path_pattern  {
      values = ["/v1/graphql/*"]
    }
  }
}
