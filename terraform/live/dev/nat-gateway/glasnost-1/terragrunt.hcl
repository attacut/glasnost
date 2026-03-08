include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/aws/nat-gateway"
}

dependency "vpc" {
  config_path = "../../vpc/glasnost-1"

  mock_outputs = {
    vpc_id   = "vpc-mock-id"
    vpc_name = "glasnost-1"
  }
}

dependency "subnets" {
  config_path = "../../subnets/glasnost-1"

  mock_outputs = {
    subnet_ids = {
      "glasnost-1-public-1" = "subnet-mock-public-1"
      "glasnost-1-public-2" = "subnet-mock-public-2"
    }
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  enabled    = false # set to false to destroy NAT Gateway and EIP without removing this config
  subnet_ids = dependency.subnets.outputs.subnet_ids

  # One NAT Gateway per AZ (ap-southeast-1a, 1b) for high availability
  nat_gateways = [
    {
      name        = "${dependency.vpc.outputs.vpc_name}-nat-1"
      subnet_name = "${dependency.vpc.outputs.vpc_name}-public-1"
    }
  ]

  tags = {
    Environment = "dev"
    Project     = "glasnost"
  }
}
