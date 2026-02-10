include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/aws/subnets"
}

dependency "vpc" {
  config_path = "../../vpc/glasnost-1"
  
  mock_outputs = {
    vpc_id = "vpc-mock-id"
  }
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id

  subnets = [
    {
      name = "public-1"
      cidr = "172.16.100.0/24"
      az   = "ap-southeast-1a"
      type = "public"
    },
    {
      name = "public-2"
      cidr = "172.16.101.0/24"
      az   = "ap-southeast-1b"
      type = "public"
    },

    {
      name = "private-1"
      cidr = "172.16.1.0/24"
      az   = "ap-southeast-1a"
      type = "private"
    },
    {
      name = "private-2"
      cidr = "172.16.2.0/24"
      az   = "ap-southeast-1b"
      type = "private"
    },
    {
      name = "private-3"
      cidr = "172.16.3.0/24"
      az   = "ap-southeast-1c"
      type = "private"
    }
  ]

  tags = {
    Environment = "dev"
    Project     = "glasnost"
  }
}
