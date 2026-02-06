# Include root configuration
include "root" {
  path = find_in_parent_folders("root.hcl")
}

# Use the VPC module
terraform {
  source = "../../../modules/aws/vpc"
}

# Input variables for the VPC module
inputs = {
  vpc_name  = "glasnost-dev-vpc"
  vpc_cidr  = "10.0.0.0/16"
  
  subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]
  
  availability_zones = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"
  ]
  
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Environment = "dev"
    Tier        = "network"
  }
}
