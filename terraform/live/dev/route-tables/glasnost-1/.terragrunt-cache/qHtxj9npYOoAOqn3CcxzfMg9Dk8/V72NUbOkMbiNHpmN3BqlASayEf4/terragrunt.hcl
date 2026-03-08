include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/aws/route-tables"
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
      "glasnost-1-public-1"  = "subnet-mock-public-1"
      "glasnost-1-public-2"  = "subnet-mock-public-2"
      "glasnost-1-private-1" = "subnet-mock-private-1"
      "glasnost-1-private-2" = "subnet-mock-private-2"
      "glasnost-1-private-3" = "subnet-mock-private-3"
    }
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "igw" {
  config_path = "../../internet-gateway/glasnost-1"

  mock_outputs = {
    igw_id = "igw-mock-id"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "nat" {
  config_path = "../../nat-gateway/glasnost-1"

  mock_outputs = {
    nat_gateway_ids = {
      "glasnost-1-nat-1" = "nat-mock-id-1"
    }
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  vpc_id     = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.subnets.outputs.subnet_ids

  route_tables = [
    {
      name        = "${dependency.vpc.outputs.vpc_name}-public-1-rt"
      subnet_name = "${dependency.vpc.outputs.vpc_name}-public-1"
      routes = [
        {
          cidr_block = "0.0.0.0/0"
          gateway_id = dependency.igw.outputs.igw_id
        },
      ]
    },
    {
      name        = "${dependency.vpc.outputs.vpc_name}-public-2-rt"
      subnet_name = "${dependency.vpc.outputs.vpc_name}-public-2"
      routes = [
        {
          cidr_block = "0.0.0.0/0"
          gateway_id = dependency.igw.outputs.igw_id
        },
      ]
    },
    {
      name        = "${dependency.vpc.outputs.vpc_name}-private-1-rt"
      subnet_name = "${dependency.vpc.outputs.vpc_name}-private-1"
      routes = [
        {
          cidr_block     = "0.0.0.0/0"
          nat_gateway_id = lookup(dependency.nat.outputs.nat_gateway_ids, "${dependency.vpc.outputs.vpc_name}-nat-1", null)
        },
      ]
    },
    {
      name        = "${dependency.vpc.outputs.vpc_name}-private-2-rt"
      subnet_name = "${dependency.vpc.outputs.vpc_name}-private-2"
      routes = [
        {
          cidr_block     = "0.0.0.0/0"
          nat_gateway_id = lookup(dependency.nat.outputs.nat_gateway_ids, "${dependency.vpc.outputs.vpc_name}-nat-1", null)
        },
      ]
    },
    {
      name        = "${dependency.vpc.outputs.vpc_name}-private-3-rt"
      subnet_name = "${dependency.vpc.outputs.vpc_name}-private-3"
      routes = [
        {
          cidr_block     = "0.0.0.0/0"
          nat_gateway_id = lookup(dependency.nat.outputs.nat_gateway_ids, "${dependency.vpc.outputs.vpc_name}-nat-1", null)
        },
      ]
    },
  ]

  tags = {
    Environment = "dev"
    Project     = "glasnost"
  }
}

