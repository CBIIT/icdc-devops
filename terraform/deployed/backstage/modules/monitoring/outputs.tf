output "backstage_source_url" {
  value       = regex("([^/]+)(?:[^/]+$)", sumologic_http_source.backstage_source.url)[0]
  description = "backstage source url"
}