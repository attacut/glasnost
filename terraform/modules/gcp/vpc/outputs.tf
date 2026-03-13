output "vpc_id" {
  description = "The unique identifier of the VPC network"
  value       = google_compute_network.this.id
}

output "vpc_name" {
  description = "The name of the VPC network"
  value       = google_compute_network.this.name
}

output "vpc_self_link" {
  description = "The self link of the VPC network (used for referencing in other GCP resources)"
  value       = google_compute_network.this.self_link
}

output "gateway_ipv4" {
  description = "The gateway address for default routing"
  value       = google_compute_network.this.gateway_ipv4
}

output "shared_vpc_host_enabled" {
  description = "Whether this project is enabled as a Shared VPC host"
  value       = var.shared_vpc_host
}

output "service_project_ids" {
  description = "List of service project IDs attached to this host project"
  value       = var.shared_vpc_host ? var.service_project_ids : []
}
