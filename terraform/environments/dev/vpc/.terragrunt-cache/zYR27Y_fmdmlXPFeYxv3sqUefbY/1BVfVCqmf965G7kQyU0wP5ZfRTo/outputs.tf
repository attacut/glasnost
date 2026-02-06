output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.this.arn
}

output "subnet_ids" {
  description = "List of subnet IDs"
  value       = aws_subnet.this[*].id
}

output "subnet_arns" {
  description = "List of subnet ARNs"
  value       = aws_subnet.this[*].arn
}