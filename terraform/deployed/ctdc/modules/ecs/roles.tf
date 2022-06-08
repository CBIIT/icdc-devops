
resource "aws_iam_role" "ecs-service-role" {
  name                 = "${var.iam_prefix}-${var.stack_name}-ecs-service-role-${terraform.workspace}"
  path                 = "/"
  assume_role_policy   = data.aws_iam_policy_document.ecs-service-policy.json
  permissions_boundary = local.permission_boundary_arn
}

resource "aws_iam_role_policy_attachment" "ecs-service-role-attachment" {
  role       = aws_iam_role.ecs-service-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"

}

resource "aws_iam_role" "task_execution_role" {
  name                 = "${var.iam_prefix}-${var.stack_name}-task-execution-role-${terraform.workspace}"
  assume_role_policy   = data.aws_iam_policy_document.task_execution_policy.json
  permissions_boundary = local.permission_boundary_arn
}

resource "aws_iam_role" "task_role" {
  name                 = "${var.iam_prefix}-${var.stack_name}-task-role-${terraform.workspace}"
  assume_role_policy   = data.aws_iam_policy_document.task_execution_policy.json
  permissions_boundary = local.permission_boundary_arn
}

resource "aws_iam_role_policy_attachment" "task-execution-role-policy-attachment" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


data "aws_iam_policy_document" "ecs-service-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "task_execution_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect = "Allow"
    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
  }
}