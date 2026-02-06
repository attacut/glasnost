# Include root configuration
include "root" {
  path = find_in_parent_folders("root.hcl")
}

# Use the VPC module
terraform {
  source = "../../../modules/aws/vpc"
}

inputs = {
  vpc_name  = "glasnost-vpc"
  vpc_cidr  = "172.16.0.0/16"
  
  public_subnets = [
    "172.16.100.0/24",
  ]
  
  private_subnets = [
    "172.16.1.0/24",
    "172.16.2.0/24",
    "172.16.3.0/24"
  ]
  
  availability_zones = [
    "ap-southeast-1a",
    "ap-southeast-1b",
    "ap-southeast-1c"
  ]
  
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Environment = "dev"
    Tier        = "network"
  }
}
