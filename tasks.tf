
variable "container_definition" {}

resource "aws_ecs_task_definition" "task" {
  for_each                 = var.microservices
  family                   = "${var.stack_name}-${var.env}-${each.value.name}"
  network_mode             = var.ecs_network_mode
  requires_compatibilities = ["FARGATE"]
  cpu                      = each.value.cpu
  memory                   = each.value.memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = each.value.name
      image     = each.value.image_url
      essential = true
      portMappings = [
        {
          protocol      = "tcp"
          containerPort = each.value.port
        }
      ]
    }
  ])

  tags = merge(
    {
      "Name" = format("%s-%s-%s-%s", var.stack_name, var.env, each.value.name, "task-definition")
    },
    var.tags,
  )
}
