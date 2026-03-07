output "nat_gateway_ids" {
  description = "Map of NAT Gateway names to IDs"
  value       = { for k, v in aws_nat_gateway.this : k => v.id }
}

output "eip_public_ips" {
  description = "Map of NAT Gateway names to their public Elastic IPs"
  value       = { for k, v in aws_eip.this : k => v.public_ip }
}
