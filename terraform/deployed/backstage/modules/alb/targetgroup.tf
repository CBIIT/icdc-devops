#create alb target group
resource "aws_lb_target_group" "backstage_target_group" {
  name        = "${var.app}-${terraform.workspace}"
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 1800
    enabled         = true
  }
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = merge(
    {
      "Name" = format("%s-%s", var.app, "backstage-alb-target-group")
    },
    var.tags,
  )
}

resource "aws_lb_listener_rule" "backstage_alb_listener" {
  listener_arn = aws_lb_listener.listener_https.arn
  priority     = var.alb_rule_priority
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backstage_target_group.arn
  }

  condition {
    host_header {
      values = ["${var.domain_url}"]
    }
  }
  condition {
    path_pattern {
      values = ["/*"]
    }
  }

}