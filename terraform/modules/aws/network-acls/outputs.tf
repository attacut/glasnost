output "network_acl_ids" {
  description = "Map of Network ACL names to IDs"
  value       = { for k, v in aws_network_acl.this : k => v.id }
}

output "network_acl_arns" {
  description = "Map of Network ACL names to ARNs"
  value       = { for k, v in aws_network_acl.this : k => v.arn }
}
