# create alb
resource "aws_lb" "alb" {

  name               = "${var.stack_name}-${var.alb_name}-${var.env}"
  load_balancer_type = var.lb_type
  subnets            = var.subnets
  security_groups    = [aws_security_group.alb-sg.id]

  access_logs  {
    bucket  = local.alb_s3_bucket_name
    prefix  = "alb-logs"
    enabled = true
  }

  timeouts {
    create = "10m"
  }

  tags = merge(
    {
      "Name" = format("%s-%s", var.stack_name, var.env)
    },
    var.tags,
  )
}

#create https redirect
resource "aws_lb_listener" "redirect_https" {

  load_balancer_arn = aws_lb.alb.arn
  port              = local.http_port
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = local.https_port
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "listener_https" {

  load_balancer_arn = aws_lb.alb.arn
  port              = local.https_port
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = var.default_message
      status_code  = "200"
    }
  }
}