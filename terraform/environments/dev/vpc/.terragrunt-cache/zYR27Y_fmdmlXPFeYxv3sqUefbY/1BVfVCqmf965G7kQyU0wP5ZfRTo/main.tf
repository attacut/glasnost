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

resource "aws_subnet" "this" {
  count                   = length(var.subnets)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.subnets[count.index]
  availability_zone       = length(var.availability_zones) > 0 ? var.availability_zones[count.index % length(var.availability_zones)] : null

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-subnet-${count.index + 1}"
    }
  )
}

