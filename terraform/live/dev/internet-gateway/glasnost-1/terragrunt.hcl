include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/aws/internet-gateway"
}

dependency "vpc" {
  config_path = "../../vpc/glasnost-1"

  mock_outputs = {
    vpc_id   = "vpc-mock-id"
    vpc_name = "glasnost-1"
  }
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id
  name   = "${dependency.vpc.outputs.vpc_name}-igw"

  tags = {
    Environment = "dev"
    Project     = "glasnost"
  }
}
