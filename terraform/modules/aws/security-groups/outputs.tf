output "security_group_ids" {
  description = "Map of Security Group names to IDs"
  value       = { for k, v in aws_security_group.this : k => v.id }
}

output "security_group_arns" {
  description = "Map of Security Group names to ARNs"
  value       = { for k, v in aws_security_group.this : k => v.arn }
}
