output "subnet_ids" {
  description = "Map of subnet names to IDs"
  value       = { for k, v in aws_subnet.this : k => v.id }
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [for s in local.public_subnets : aws_subnet.this[s.name].id]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [for s in local.private_subnets : aws_subnet.this[s.name].id]
}

output "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  value       = [for s in local.public_subnets : aws_subnet.this[s.name].cidr_block]
}

output "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  value       = [for s in local.private_subnets : aws_subnet.this[s.name].cidr_block]
}
