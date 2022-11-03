provider "aws" {
  region = "ap-southeast-1"
}

data "aws_subnet" "eks_private_subnet_1" {
  id = var.subnet_id
}
data "aws_vpc" "eks_vpc" {
  id = var.vpc_id
}
resource "aws_vpn_gateway" "tpp_vpn_gateway" {
  vpc_id = data.aws_vpc.eks_vpc.id
  tags = {
    Name = "tpp-vpn-gateway"
  }
}

module "vpn_gateway" {
  source = "../../"

  vpn_gateway_id      = resource.aws_vpn_gateway.tpp_vpn_gateway.id
  customer_gateway_id = aws_customer_gateway.main.id

  vpc_id                       = data.aws_vpc.eks_vpc.id
  vpc_subnet_route_table_ids   = var.routetable_ids
  vpc_subnet_route_table_count = length(var.vpc_private_subnets)
  local_ipv4_network_cidr      = "0.0.0.0/0"
  remote_ipv4_network_cidr     = data.aws_vpc.eks_vpc.cidr_block
}

resource "aws_customer_gateway" "main" {
  bgp_asn    = 65000
  ip_address = var.customer_ip
  type       = "ipsec.1"

  tags = {
    Name = "complete-vpn-gateway"
  }
}



resource "aws_instance" "foo" {
  name = "test ec2 vpn in private subnet"
  ami           = "ami-007cfa135d2f26f76"
  instance_type = "t2.micro"
  vpc_security_group_ids = var.ec2_sg_group
  subnet_id              = data.aws_subnet.eks_private_subnet_1.id

  credit_specification {
    cpu_credits = "unlimited"
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Project = "TestVPN"
  } 

}

# data "aws_ami" "example" {
#   most_recent = true

#   owners = ["self"]
#   tags = {
#     Name   = "app-server"
#     Tested = "true"
#   }
# }

# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "~> 3.0"
#   # id = data.aws_vpc.vpc_id
#   name = "eksctl-tpp-print-2-cluster/VPC"

#   cidr = data.aws_vpc.eks_vpc.cidr_block

#   azs             = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
#   public_subnets  = var.vpc_public_subnets
#   private_subnets = var.vpc_private_subnets

#   enable_nat_gateway = false

#   enable_vpn_gateway = true

#   tags = {
#     Owner       = "user"
#     Environment = "staging"
#     Name        = "complete"
#   }
# }
