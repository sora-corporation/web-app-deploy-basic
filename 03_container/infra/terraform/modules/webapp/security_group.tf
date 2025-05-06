resource "aws_security_group" "private_subnets" {
  vpc_id      = module.vpc.vpc_id
  name        = "Private Subnet Access"
  description = "Allow all from private subnet"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = module.vpc.private_subnets_cidr_blocks
    description = "Allow private subnets"
  }
}

resource "aws_security_group" "public_subnets" {
  vpc_id      = module.vpc.vpc_id
  name        = "Public Subnet Access"
  description = "Allow all from public subnet"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = module.vpc.public_subnets_cidr_blocks
    description = "Allow public subnets"
  }
}

resource "aws_security_group" "vpc" {
  vpc_id      = module.vpc.vpc_id
  name        = "VPC Access"
  description = "Allow all from vpc subnet"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = concat(module.vpc.public_subnets_cidr_blocks, module.vpc.private_subnets_cidr_blocks)
    description = "Allow vpc subnets"
  }
}

resource "aws_security_group" "outbound_anywhere" {
  vpc_id = module.vpc.vpc_id
  name   = "Internet access"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "inbound_anywhere" {
  vpc_id = module.vpc.vpc_id
  name   = "Inbound Anywhere"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}