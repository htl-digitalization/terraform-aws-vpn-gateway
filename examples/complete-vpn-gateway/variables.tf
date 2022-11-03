variable "vpc_private_subnets" {
  description = "List of private subnets"
  type        = list(string)
}

variable "vpc_public_subnets" {
  description = "List of public subnets"
  type        = list(string)
}

variable "customer_ip" {
  description = "Customer connected UO"
  type        = string
}

variable "vpc_id" {
  description = "VPC id of eks cluster"
  type        = string
}


variable "subnet_id" {
  description = "1 Subnet id of eks cluster"
  type        = string
}

variable "routetable_ids" {
  description = "route table ids"
  type        = list(string)
}

variable "ec2_sg_group" {
  description = "ec2 sg group"
  type        = list(string)
}