# Sumologic
# Create a collector
resource "sumologic_collector" "collector" {
  name = "${var.app}-${terraform.workspace}"
}

# Create an HTTP source - frontend
resource "sumologic_http_source" "backstage_source" {
  name         = "backstage"
  category     = "${var.app}/${terraform.workspace}"
  collector_id = sumologic_collector.collector.id
}