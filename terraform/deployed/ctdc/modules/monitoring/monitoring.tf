# Sumologic
# Create a collector
resource "sumologic_collector" "collector" {
    name = "${var.app}-${terraform.workspace}"
}

# Create an HTTP source - frontend
resource "sumologic_http_source" "frontend_source" {
    name         = "frontend"
    category     = "${var.app}/${terraform.workspace}/frontend"
    collector_id = "${sumologic_collector.collector.id}"
}

# Create an HTTP source - backend
resource "sumologic_http_source" "backend_source" {
    name         = "backend"
    category     = "${var.app}/${terraform.workspace}/backend"
    collector_id = "${sumologic_collector.collector.id}"
}

# Create an HTTP source - files
resource "sumologic_http_source" "files_source" {
    name         = "files"
    category     = "${var.app}/${terraform.workspace}/files"
    collector_id = "${sumologic_collector.collector.id}"
}