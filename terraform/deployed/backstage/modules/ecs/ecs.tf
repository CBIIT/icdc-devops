#create ecs cluster
resource "aws_appautoscaling_target" "backstage_target" {
  max_capacity       = 2
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service_backstage.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "backstage_scaling_cpu" {
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.backstage_target.resource_id
  scalable_dimension = aws_appautoscaling_target.backstage_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.backstage_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 80
  }
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.app}-${terraform.workspace}"

  tags = merge(
    {
      "Name" = local.cluster_name
    },
    var.tags,
  )

}

resource "aws_ecs_service" "ecs_service_backstage" {
  name                               = "${var.app}-${terraform.workspace}-backstage"
  cluster                            = aws_ecs_cluster.ecs_cluster.id
  task_definition                    = aws_ecs_task_definition.backstage.arn
  desired_count                      = var.container_replicas
  launch_type                        = var.ecs_launch_type
  scheduling_strategy                = var.ecs_scheduling_strategy
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  network_configuration {
    security_groups  = [aws_security_group.app_sg.id]
    subnets          = var.private_subnets
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "backstage"
    container_port   = var.container_port
  }
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}

resource "aws_ecs_task_definition" "backstage" {
  family                   = "${var.app}-${terraform.workspace}-backstage"
  network_mode             = var.ecs_network_mode
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn
  container_definitions = jsonencode([
    {
      name      = "backstage"
      image     = "${var.container_image_name}"
      essential = true
      portMappings = [
        {
          protocol      = "tcp"
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]
  }])
  tags = merge(
    {
      "Name" = format("%s-%s-%s", var.app, terraform.workspace, "task-definition")
    },
    var.tags,
  )
}