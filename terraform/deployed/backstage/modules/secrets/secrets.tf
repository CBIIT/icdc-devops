resource "aws_secretsmanager_secret" "secrets" {
  name = "${var.app}"

}

resource "aws_secretsmanager_secret_version" "secrets_values" {
  secret_id     = aws_secretsmanager_secret.secrets.id
  secret_string = <<EOF
    {
	  "sumo_collector_endpoint": "collectors.fed.sumologic.com",
	  "sumo_collector_token": "${var.sumo_collector_token}",
	  "postgres_password": "${var.postgres_password}",
	  "postgres_endpoint": "${var.postgres_endpoint}",
	  "github_token": "${var.github_token}"
	  
	}
EOF
}