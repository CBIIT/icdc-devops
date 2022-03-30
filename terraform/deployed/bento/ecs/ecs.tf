#create ecs cluster
resource "aws_appautoscaling_target" "frontend_target" {
  max_capacity       = 5
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service_frontend.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_target" "backend_target" {
  max_capacity       = 5
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service_backend.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "backend_scaling_cpu" {
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.backend_target.resource_id
  scalable_dimension = aws_appautoscaling_target.backend_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.backend_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 80
  }
}


resource "aws_appautoscaling_policy" "frontend_scaling_cpu" {
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.frontend_target.resource_id
  scalable_dimension = aws_appautoscaling_target.frontend_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.frontend_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 80
  }
}


resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.stack_name}-${terraform.workspace}-ecs"

  tags = merge(
  {
    "Name" = format("%s-%s",var.stack_name,"ecs-cluster")
  },
  var.tags,
  )

}

 resource "aws_ecs_service" "ecs_service_backend" {
   name              = "${var.stack_name}-${terraform.workspace}-backend"
   cluster           = aws_ecs_cluster.ecs_cluster.id
   task_definition   = aws_ecs_task_definition.backend.arn
   desired_count     = var.number_container_replicas
   launch_type       = var.ecs_launch_type
   scheduling_strategy = var.ecs_scheduling_strategy
   deployment_minimum_healthy_percent = 50
   deployment_maximum_percent         = 200
   network_configuration {
     security_groups  = [aws_security_group.app_sg.id]
     subnets          = var.private_subnets
     assign_public_ip = false
   }
   load_balancer {
     target_group_arn = aws_lb_target_group.backend_target_group.arn
     container_name   = "backend"
     container_port   = var.backend_container_port
   }
   lifecycle {
     ignore_changes = [task_definition, desired_count]
   }
 }

resource "aws_ecs_service" "ecs_service_frontend" {
  name              = "${var.stack_name}-${terraform.workspace}-frontend"
  cluster           = aws_ecs_cluster.ecs_cluster.id
  task_definition   = aws_ecs_task_definition.frontend.arn
  desired_count     = var.number_container_replicas
  launch_type       = var.ecs_launch_type
  scheduling_strategy = var.ecs_scheduling_strategy
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  network_configuration {
    security_groups  = [aws_security_group.app_sg.id]
    subnets          = var.private_subnets
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.frontend_target_group.arn
    container_name   = "frontend"
    container_port   = var.frontend_container_port
  }
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}

resource "aws_ecs_task_definition" "frontend" {
  family        = "${var.stack_name}-${terraform.workspace}-frontend"
  network_mode  = var.ecs_network_mode
  requires_compatibilities = ["FARGATE"]
  cpu = "256"
  memory = "512"
  execution_role_arn =  aws_iam_role.task_execution_role.arn
  task_role_arn = aws_iam_role.task_role.arn
  container_definitions = jsonencode([
    {
      name         = "frontend"
      image        = "${var.frontend_container_image_name}:latest"
      essential    = true
      portMappings = [
        {
          protocol      = "tcp"
          containerPort = var.frontend_container_port
          hostPort      = var.frontend_container_port
        }
      ]
    }])
  tags = merge(
  {
    "Name" = format("%s-%s-%s",var.stack_name,terraform.workspace,"task-definition")
  },
  var.tags,
  )
}


resource "aws_ecs_task_definition" "backend" {
  family        = "${var.stack_name}-${terraform.workspace}-backend"
  network_mode  = var.ecs_network_mode
  requires_compatibilities = ["FARGATE"]
  cpu = "512"
  memory = "1024"
  execution_role_arn =  aws_iam_role.task_execution_role.arn
  task_role_arn = aws_iam_role.task_role.arn
  container_definitions = jsonencode([
    {
      name         = "backend"
      image        = "${var.backend_container_image_name}:latest"
      essential    = true
      portMappings = [
        {
          protocol      = "tcp"
          containerPort = var.backend_container_port
          hostPort      = var.backend_container_port
        }
      ]
    }])
  tags = merge(
  {
    "Name" = format("%s-%s-%s",var.stack_name,terraform.workspace,"task-definition")
  },
  var.tags,
  )
}

resource "aws_security_group" "app_sg" {
  name = "${var.stack_name}-${terraform.workspace}-app-sg"
  vpc_id = var.vpc_id
  tags = merge(
  {
    "Name" = format("%s-%s-frontend-sg",var.stack_name,terraform.workspace),
  },
  var.tags,
  )
}

resource "aws_security_group_rule" "inbound_frontend_alb" {
  from_port = var.frontend_container_port
  protocol = local.tcp_protocol
  to_port = var.frontend_container_port
  security_group_id = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.alb-sg.id
  type = "ingress"
}

resource "aws_security_group_rule" "inbound_backend_alb" {
  from_port = var.backend_container_port
  protocol = local.tcp_protocol
  to_port = var.backend_container_port
  security_group_id = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.alb-sg.id
  type = "ingress"
}

resource "aws_security_group_rule" "all_outbound_frontend" {
  from_port = local.any_port
  protocol = local.any_protocol
  to_port = local.any_port
  cidr_blocks = local.all_ips
  security_group_id = aws_security_group.app_sg.id
  type = "egress"
}

#create alb target group
resource "aws_lb_target_group" "frontend_target_group" {
  name = "${var.stack_name}-${terraform.workspace}-frontend"
  port = var.frontend_container_port
  protocol = "HTTP"
  vpc_id =  var.vpc_id
  target_type = var.alb_target_type
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
  vpc_id =  var.vpc_id
  target_type = var.alb_target_type
  stickiness {
    type = "lb_cookie"
    cookie_duration = 1800
    enabled = true
  }
  health_check {
    path = "/ping"
    protocol = "HTTP"
    port = var.backend_container_port
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

resource "aws_lb_listener_rule" "frontend_alb_listener_prod" {
  listener_arn = aws_lb_listener.listener_https.arn
  priority = var.fronted_rule_priority
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.frontend_target_group.arn
  }

  condition {
    host_header {
      values = [local.app_url]
    }
  }
  condition {
    path_pattern  {
      values = ["/*"]
    }
  }
}

resource "aws_lb_listener_rule" "bento_www" {
  count =   terraform.workspace ==  "prod"  ? 1:0
  listener_arn = aws_lb_listener.listener_https.arn
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.frontend_target_group.arn
  }

  condition {
    host_header {
      values = ["www.${local.app_url}"]
    }
  }
  condition {
    path_pattern  {
      values = ["/*"]
    }
  }
}

resource "aws_lb_listener_rule" "backend_alb_listener_prod" {
  listener_arn = aws_lb_listener.listener_https.arn
  priority = var.backend_rule_priority
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.backend_target_group.arn
  }

  condition {
    host_header {
      values = [local.app_url]
    }
  }
  condition {
    path_pattern  {
      values = ["/v1/graphql/*"]
    }
  }
}
