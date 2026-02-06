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
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = length(var.availability_zones) > 0 ? var.availability_zones[count.index % length(var.availability_zones)] : null
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-${length(var.availability_zones) > 0 ? var.availability_zones[count.index % length(var.availability_zones)] : "az${count.index + 1}"}-public-${count.index + 1}"
      Type = "public"
    }
  )
}

# Private Subnets
resource "aws_subnet" "private" {
  count                   = length(var.private_subnets)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnets[count.index]
  availability_zone       = length(var.availability_zones) > 0 ? var.availability_zones[count.index % length(var.availability_zones)] : null
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-${length(var.availability_zones) > 0 ? var.availability_zones[count.index % length(var.availability_zones)] : "az${count.index + 1}"}-private-${count.index + 1}"
      Type = "private"
    }
  )
}

