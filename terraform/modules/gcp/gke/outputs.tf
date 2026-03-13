output "cluster_id" {
  description = "The unique identifier of the cluster"
  value       = google_container_cluster.this.id
}

output "cluster_name" {
  description = "The name of the cluster"
  value       = google_container_cluster.this.name
}

output "cluster_endpoint" {
  description = "The IP address of the master endpoint"
  value       = google_container_cluster.this.endpoint
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Base64 encoded public certificate of the cluster CA"
  value       = google_container_cluster.this.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "cluster_location" {
  description = "The region or zone of the cluster"
  value       = google_container_cluster.this.location
}

output "node_pool_ids" {
  description = "Map of node pool names to their IDs"
  value       = { for k, v in google_container_node_pool.this : k => v.id }
}
