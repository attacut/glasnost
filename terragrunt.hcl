# Terragrunt configuration for VPC module

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    bucket         = "my-terraform-state-bucket"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
}

# Configure the Terraform source
terraform {
  source = "./terraform/aws/modules/vpc"
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "ap-southeast-1"
}
EOF
}

# Input variables for the VPC module
inputs = {
  vpc_name = "my-vpc"
  vpc_cidr = "10.0.0.0/16"
  
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Environment = "development"
    Project     = "glasnost"
    ManagedBy   = "Terragrunt"
  }
}
