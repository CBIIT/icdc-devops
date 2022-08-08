resource "aws_iam_instance_profile" "integration_server" {
  name = local.integration_server_profile_name
  role = aws_iam_role.integration_server.name
}

resource "aws_iam_role" "integration_server" {
  name                 = local.integration_server_profile_name
  assume_role_policy   = data.aws_iam_policy_document.integration_server_assume_role.json
  permissions_boundary = terraform.workspace == "prod" ? null : local.permissions_boundary
}

resource "aws_iam_policy" "integration_server" {
  name        = "${local.integration_server_profile_name}-policy"
  description = "IAM Policy for the integration server host in this account"
  policy      = data.aws_iam_policy_document.integration_server_policy.json
}

resource "aws_iam_role_policy_attachment" "integration_server" {
  role       = aws_iam_role.integration_server.name
  policy_arn = aws_iam_policy.integration_server.arn
}

resource "aws_iam_role_policy_attachment" "managed_ecr" {
  for_each = toset(local.managed_policy_arns)
  role       = aws_iam_role.integration_server.name
  policy_arn = each.key
}
