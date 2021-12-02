terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpcname
  cidr = var.vpccidr

  azs                   = slice(data.aws_availability_zones.azs.names, 0, 2)
  private_subnets       = var.privatesubnet
  public_subnets        = var.publicsubnet
  create_igw            = true
  enable_nat_gateway    = false
  enable_vpn_gateway    = false
  private_subnet_suffix = var.privatesubnetname
  public_subnet_suffix  = var.publicsubnetname
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

data "aws_availability_zones" "azs" {
  state = "available"
}