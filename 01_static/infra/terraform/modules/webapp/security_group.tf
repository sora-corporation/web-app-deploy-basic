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

resource "aws_security_group" "bastion" {
  vpc_id      = module.vpc.vpc_id
  name        = "Bastion"
  description = "Allow Bastion Access"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.whitelist_cidr_blocks
  }
}

resource "aws_security_group" "maintenance" {
  vpc_id = module.vpc.vpc_id
  name   = "Maintenance"
}

resource "aws_security_group_rule" "bastion_to_maintenance" {
  type                     = "egress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.bastion.id
  source_security_group_id = aws_security_group.maintenance.id
}

resource "aws_security_group_rule" "maintenance_from_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.maintenance.id
  source_security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group" "web_app" {
  vpc_id = module.vpc.vpc_id
  name   = "Web Application"
}

resource "aws_security_group" "lb" {
  vpc_id = module.vpc.vpc_id
  name   = "Load Balancer"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "lb_to_webapp" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.lb.id
  source_security_group_id = aws_security_group.web_app.id
}

resource "aws_security_group_rule" "webapp_from_lb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.web_app.id
  source_security_group_id = aws_security_group.lb.id
}
