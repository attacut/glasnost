include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/aws/security-groups"
}

dependency "vpc" {
  config_path = "../../vpc/glasnost-1"

  mock_outputs = {
    vpc_id      = "vpc-mock-id"
    vpc_name    = "glasnost-1"
    vpc_cidr_block = "172.16.0.0/16"
  }
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id

  security_groups = [
    # Public-facing Load Balancer
    {
      name        = "${dependency.vpc.outputs.vpc_name}-alb-sg"
      description = "Security group for public ALB"
      ingress_rules = [
        {
          description = "Allow HTTP from internet"
          ip_protocol = "tcp"
          from_port   = 80
          to_port     = 80
          cidr_ipv4   = "0.0.0.0/0"
        },
        {
          description = "Allow HTTPS from internet"
          ip_protocol = "tcp"
          from_port   = 443
          to_port     = 443
          cidr_ipv4   = "0.0.0.0/0"
        },
      ]
      egress_rules = [
        {
          description = "Allow all outbound"
          ip_protocol = "-1"
          cidr_ipv4   = "0.0.0.0/0"
        },
      ]
    },

    # Application servers (private subnet)
    {
      name        = "${dependency.vpc.outputs.vpc_name}-app-sg"
      description = "Security group for application servers"
      ingress_rules = [
        {
          description = "Allow traffic from VPC"
          ip_protocol = "tcp"
          from_port   = 8080
          to_port     = 8080
          cidr_ipv4   = dependency.vpc.outputs.vpc_cidr_block
        },
        {
          description = "Allow SSH from VPC"
          ip_protocol = "tcp"
          from_port   = 22
          to_port     = 22
          cidr_ipv4   = dependency.vpc.outputs.vpc_cidr_block
        },
      ]
      egress_rules = [
        {
          description = "Allow all outbound"
          ip_protocol = "-1"
          cidr_ipv4   = "0.0.0.0/0"
        },
      ]
    },

    # Database (private subnet)
    {
      name        = "${dependency.vpc.outputs.vpc_name}-db-sg"
      description = "Security group for databases"
      ingress_rules = [
        {
          description = "Allow PostgreSQL from VPC"
          ip_protocol = "tcp"
          from_port   = 5432
          to_port     = 5432
          cidr_ipv4   = dependency.vpc.outputs.vpc_cidr_block
        },
      ]
      egress_rules = [
        {
          description = "Allow all outbound"
          ip_protocol = "-1"
          cidr_ipv4   = "0.0.0.0/0"
        },
      ]
    },
  ]

  tags = {
    Environment = "dev"
    Project     = "glasnost"
  }
}
