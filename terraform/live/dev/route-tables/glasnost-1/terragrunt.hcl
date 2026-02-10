include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/aws/route-tables"
}

dependency "vpc" {
  config_path = "../../vpc/glasnost-1"
  
  mock_outputs = {
    vpc_id = "vpc-mock-id"
  }
}

dependency "subnets" {
  config_path = "../../subnets/glasnost-1"
  
  mock_outputs = {
    subnet_ids = {
      "public-1"  = "subnet-mock-public-1"
      "public-2"  = "subnet-mock-public-2"
      "private-1" = "subnet-mock-private-1"
      "private-2" = "subnet-mock-private-2"
      "private-3" = "subnet-mock-private-3"
    }
  }
}

inputs = {
  vpc_id     = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.subnets.outputs.subnet_ids

  route_tables = [
    {
      name        = "public-1-rt"
      subnet_name = "public-1"
    },
    {
      name        = "public-2-rt"
      subnet_name = "public-2"
    },
    {
      name        = "private-1-rt"
      subnet_name = "private-1"
    },
    {
      name        = "private-2-rt"
      subnet_name = "private-2"
    },
    {
      name        = "private-3-rt"
      subnet_name = "private-3"
    }
  ]

  tags = {
    Environment = "dev"
    Project     = "glasnost"
  }
}
