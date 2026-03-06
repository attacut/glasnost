include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/aws/networkacls"
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

inputs = {
  vpc_id     = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.subnets.outputs.subnet_ids

  network_acls = [
    {
      name         = "${dependency.vpc.outputs.vpc_name}-public-nacl"
      subnet_names = [
        "${dependency.vpc.outputs.vpc_name}-public-1",
        "${dependency.vpc.outputs.vpc_name}-public-2",
      ]
      ingress_rules = [
        {
          rule_no    = 100
          protocol   = "tcp"
          action     = "allow"
          cidr_block = "0.0.0.0/0"
          from_port  = 80
          to_port    = 80
        },
        {
          rule_no    = 110
          protocol   = "tcp"
          action     = "allow"
          cidr_block = "0.0.0.0/0"
          from_port  = 443
          to_port    = 443
        },
        {
          rule_no    = 120
          protocol   = "tcp"
          action     = "allow"
          cidr_block = "0.0.0.0/0"
          from_port  = 22
          to_port    = 22
        },
        {
          rule_no    = 130
          protocol   = "tcp"
          action     = "allow"
          cidr_block = "0.0.0.0/0"
          from_port  = 1024
          to_port    = 65535
        },
        {
          rule_no    = 32766
          protocol   = "-1"
          action     = "deny"
          cidr_block = "0.0.0.0/0"
          from_port  = 0
          to_port    = 0
        },
      ]
      egress_rules = [
        {
          rule_no    = 100
          protocol   = "-1"
          action     = "allow"
          cidr_block = "0.0.0.0/0"
          from_port  = 0
          to_port    = 0
        },
      ]
    },
    {
      name         = "${dependency.vpc.outputs.vpc_name}-private-nacl"
      subnet_names = [
        "${dependency.vpc.outputs.vpc_name}-private-1",
        "${dependency.vpc.outputs.vpc_name}-private-2",
        "${dependency.vpc.outputs.vpc_name}-private-3",
      ]
      ingress_rules = [
        {
          rule_no    = 100
          protocol   = "-1"
          action     = "allow"
          cidr_block = "172.16.0.0/16"
          from_port  = 0
          to_port    = 0
        },
        {
          rule_no    = 110
          protocol   = "tcp"
          action     = "allow"
          cidr_block = "0.0.0.0/0"
          from_port  = 1024
          to_port    = 65535
        },
        {
          rule_no    = 32766
          protocol   = "-1"
          action     = "deny"
          cidr_block = "0.0.0.0/0"
          from_port  = 0
          to_port    = 0
        },
      ]
      egress_rules = [
        {
          rule_no    = 100
          protocol   = "-1"
          action     = "allow"
          cidr_block = "0.0.0.0/0"
          from_port  = 0
          to_port    = 0
        },
      ]
    },
  ]

  tags = {
    env         = "dev"
    project     = "glasnost"
  }
}
