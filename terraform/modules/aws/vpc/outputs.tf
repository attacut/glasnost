output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.this.arn
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "subnet_ids" {
  description = "List of IDs of subnets"
  value       = aws_subnet.this[*].id
}

output "subnet_cidr_blocks" {
  description = "List of CIDR blocks of subnets"
  value       = aws_subnet.this[*].cidr_block
}