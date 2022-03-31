#task definition
resource "aws_ecs_task_definition" "task" {
  for_each = var.microservices
  family        = "${var.stack_name}-${var.env}-${each.value.name}"
  network_mode  = var.ecs_network_mode
  requires_compatibilities = ["FARGATE"]
  cpu = each.value.cpu
  memory = each.value.memory
  execution_role_arn =  aws_iam_role.task_execution_role.arn
  task_role_arn = aws_iam_role.task_role.arn
  container_definitions = jsonencode([
    {
      name         =  each.value.name
      image        =  each.value.image_url
      essential    = true
      portMappings = [
        {
          protocol      = "tcp"
          containerPort = each.value.port
#          hostPort      = var.microservice_port
        }
      ]
    }])
  tags = merge(
  {
    "Name" = format("%s-%s-%s-%s",var.stack_name,var.env,each.value.name,"task-definition")
  },
  var.tags,
  )
}
#ecs service
resource "aws_ecs_service" "service" {
  for_each = var.microservices
  name              = "${var.stack_name}-${var.env}-${each.value.name}"
  cluster           = aws_ecs_cluster.ecs_cluster.id
  task_definition   = aws_ecs_task_definition.task[each.key].arn
  desired_count     = var.number_container_replicas
  launch_type       = var.ecs_launch_type
  scheduling_strategy = var.ecs_scheduling_strategy
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  network_configuration {
    security_groups  = [aws_security_group.app_sg.id]
    subnets          = var.private_subnet_ids
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.target_group[each.key].arn
    container_name   =  each.value.name
    container_port   =  each.value.port
  }
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}


#create ecs cluster
resource "aws_appautoscaling_target" "microservice_autoscaling_target" {
  for_each = var.microservices
  max_capacity       = 5
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.service[each.key].name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "microservice_autoscaling_cpu" {
  for_each = var.microservices
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.microservice_autoscaling_target[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.microservice_autoscaling_target[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.microservice_autoscaling_target[each.key].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 80
  }
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.stack_name}-${var.env}-ecs"
  tags = merge(
  {
    "Name" = format("%s-%s",var.stack_name,"ecs-cluster")
  },
  var.tags,
  )

}

resource "aws_security_group" "fargate_sg" {
  name = "${var.stack_name}-${var.env}-fargate-sg"
  vpc_id = var.vpc_id
  tags = merge(
  {
    "Name" = format("%s-%s-fargate-sg",var.stack_name,var.env),
  },
  var.tags,
  )
}

resource "aws_security_group_rule" "all_outbound_fargate" {
  from_port = local.any_port
  protocol = local.any_protocol
  to_port = local.any_port
  cidr_blocks = local.all_ips
  security_group_id = aws_security_group.fargate_sg.id
  type = "egress"
}

resource "aws_security_group_rule" "inbound_fargate" {
  for_each = toset(var.fargate_security_group_ports)
  from_port = each.key
  protocol = local.tcp_protocol
  to_port = each.key
  security_group_id = aws_security_group.fargate_sg.id
  cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  type = "ingress"
}

resource "aws_security_group" "app_sg" {
  name = "${var.stack_name}-${var.env}-app-sg"
  vpc_id = var.vpc_id
  tags = merge(
  {
    "Name" = format("%s-%s-frontend-sg",var.stack_name,var.env),
  },
  var.tags,
  )
}

resource "aws_security_group_rule" "inbound_alb" {
  from_port = var.microservice_port
  protocol = local.tcp_protocol
  to_port = var.microservice_port
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
resource "aws_lb_target_group" "target_group" {
  for_each = var.microservices
  name = "${var.stack_name}-${var.env}-${each.value.name}"
  port = each.value.port
  protocol = "HTTP"
  vpc_id =  var.vpc_id
  target_type = var.alb_target_type
  stickiness {
    type = "lb_cookie"
    cookie_duration = 1800
    enabled = true
  }
  health_check {
    path = each.value.health_check_path
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 30
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
  tags = merge(
  {
    "Name" = format("%s-%s",var.stack_name,"${each.value.name}-alb-target-group")
  },
  var.tags,
  )
}

resource "aws_lb_listener_rule" "alb_listener" {
  for_each = var.microservices
  listener_arn = aws_lb_listener.listener_https.arn
  priority = each.value.priority_rule_number
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.target_group[each.key].arn
  }

  condition {
    host_header {
      values = [var.microservice_url]
    }
  }
  condition {
    path_pattern  {
      values = [each.value.path]
    }
  }
}

