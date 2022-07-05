resource "aws_secretsmanager_secret" "secrets" {
  name = "${var.app}/${terraform.workspace}"

}

resource "aws_secretsmanager_secret_version" "secrets_values" {
  secret_id     = aws_secretsmanager_secret.secrets.id
  secret_string = <<EOF
    {
	  "sumo_collector_endpoint": "collectors.fed.sumologic.com",
	  "sumo_collector_token": "${var.sumo_collector_token}",
	}
EOF
}