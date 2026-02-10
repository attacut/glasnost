output "route_table_ids" {
  description = "Map of route table names to IDs"
  value       = { for k, v in aws_route_table.this : k => v.id }
}
