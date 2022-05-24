resource "aws_secretsmanager_secret" "secrets" {
  name = "bento/${var.app}2/${terraform.workspace}"

}

resource "aws_secretsmanager_secret_version" "secrets_values" {
  #secret_id = "bento/${var.app}1/${terraform.workspace}"
  secret_id = aws_secretsmanager_secret.secrets.id
  secret_string = <<EOF
    {
	  "es_host": "${var.es_endpoint}",
	  "neo4j_user": "${var.neo4j_user}",
	  "neo4j_password": "${var.neo4j_password}",
	  "indexd_url": "${var.indexd_url}",
	  "sumo_collector_endpoint": "collectors.fed.sumologic.com",
	  "sumo_collector_token_be": "${var.sumo_collector_token_be}",
	  "sumo_collector_token_fe": "${var.sumo_collector_token_fe}",
	  "sumo_collector_token_files": "${var.sumo_collector_token_files}"
	}
EOF
}