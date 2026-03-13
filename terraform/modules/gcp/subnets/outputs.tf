output "subnet_ids" {
  description = "Map of subnet names to IDs"
  value       = { for k, v in google_compute_subnetwork.this : k => v.id }
}

output "subnet_self_links" {
  description = "Map of subnet names to self links"
  value       = { for k, v in google_compute_subnetwork.this : k => v.self_link }
}

output "subnet_ip_cidr_ranges" {
  description = "Map of subnet names to their primary CIDR ranges"
  value       = { for k, v in google_compute_subnetwork.this : k => v.ip_cidr_range }
}

output "subnet_regions" {
  description = "Map of subnet names to their regions"
  value       = { for k, v in google_compute_subnetwork.this : k => v.region }
}
