resource "aws_secretsmanager_secret" "this" {
  for_each = var.secret_values
  name = each.value.secretKey
  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "example" {
  for_each = var.secret_values
  secret_id     = aws_secretsmanager_secret.this[each.key].id
  secret_string = jsonencode(each.value.secretValue)
}