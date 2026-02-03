terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    var.tags,
    {
      Name = var.vpc_name
    }
  )
}

# Public Subnets
resource "aws_subnet" "this" {
  count                   = length(var.subnets)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.subnets[count.index]
  availability_zone       = var.availability_zones[count.index % length(var.availability_zones)]

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-${count.index + 1}"
    }
  )
}