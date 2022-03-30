resource "aws_iam_role" "task_execution_role" {
  name = "${var.stack_name}-${var.env}-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.task_execution_policy.json
}

resource "aws_iam_role" "task_role" {
  name = "${var.stack_name}-${var.env}-task-role"
  assume_role_policy = data.aws_iam_policy_document.task_execution_policy.json
}

resource "aws_iam_role_policy_attachment" "task-execution-role-policy-attachment" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "ecs_log_policy" {
  name   = "${var.stack_name}-${var.env}-log-policy"
  policy = data.aws_iam_policy_document.task_logs_policy.json
}

resource "aws_iam_role_policy_attachment" "task-log-policy-attachment" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = aws_iam_policy.ecs_log_policy.arn
}


resource "aws_iam_policy" "ecs_policy" {
  name   = "${var.stack_name}-${var.env}-ecs-policy"
  policy = data.aws_iam_policy_document.ecs_policy_doc.json
}
resource "aws_iam_policy_attachment" "ecs_policy_attachment" {
  name  = "${var.stack_name}-${var.env}-ecs-policy-attachement"
  policy_arn = aws_iam_policy.ecs_policy.arn
  roles = [aws_iam_role.task_role.name]
}