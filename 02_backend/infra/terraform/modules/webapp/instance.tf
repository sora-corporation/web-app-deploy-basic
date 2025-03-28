# 2025/03 時点での最新の AMI ID
# aws ssm get-parameters --names /aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id
locals {
  ami_id = "ami-026c39f4021df9abe"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-${var.project}"
  public_key = var.deployer_pubkey
}

resource "aws_instance" "bastion" {
  ami                  = local.ami_id
  instance_type        = "t3.nano"
  key_name             = aws_key_pair.deployer.key_name
  iam_instance_profile = aws_iam_instance_profile.webapp.name

  user_data = file("${path.module}/user_data.sh")

  vpc_security_group_ids = [
    aws_security_group.outbound_anywhere.id,
    aws_security_group.bastion.id,
  ]
  subnet_id = module.vpc.public_subnets[0]

  tags = {
    Name = "bastion-${var.project}"
  }

  volume_tags = {
    Name = "bastion-${var.project}"
  }
}

resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  domain   = "vpc"
}

resource "aws_instance" "web_a" {
  ami                  = local.ami_id
  instance_type        = "t3.medium"
  key_name             = aws_key_pair.deployer.key_name
  iam_instance_profile = aws_iam_instance_profile.webapp.name

  user_data = file("${path.module}/user_data.sh")

  vpc_security_group_ids = [
    aws_security_group.outbound_anywhere.id,
    aws_security_group.maintenance.id,
    aws_security_group.private_subnets.id,
    aws_security_group.web_app.id,
  ]
  subnet_id = module.vpc.private_subnets[0]

  root_block_device {
    volume_type = "gp3"
    volume_size = "50"
  }

  tags = {
    Name = "web-${var.project}-a"
  }
}

resource "aws_instance" "web_c" {
  ami                  = local.ami_id
  instance_type        = "t3.medium"
  key_name             = aws_key_pair.deployer.key_name
  iam_instance_profile = aws_iam_instance_profile.webapp.name

  user_data = file("${path.module}/user_data.sh")

  vpc_security_group_ids = [
    aws_security_group.outbound_anywhere.id,
    aws_security_group.maintenance.id,
    aws_security_group.private_subnets.id,
    aws_security_group.web_app.id,
  ]
  subnet_id = module.vpc.private_subnets[1]

  root_block_device {
    volume_type = "gp3"
    volume_size = "50"
  }

  tags = {
    Name = "web-${var.project}-c"
  }
}

resource "aws_instance" "job" {
  ami                  = local.ami_id
  instance_type        = "t3.medium"
  key_name             = aws_key_pair.deployer.key_name
  iam_instance_profile = aws_iam_instance_profile.webapp.name

  user_data = file("${path.module}/user_data.sh")

  vpc_security_group_ids = [
    aws_security_group.outbound_anywhere.id,
    aws_security_group.maintenance.id,
    aws_security_group.private_subnets.id,
    aws_security_group.web_app.id,
  ]
  subnet_id = module.vpc.private_subnets[0]

  root_block_device {
    volume_type = "gp3"
    volume_size = "50"
  }

  tags = {
    Name = "job-${var.project}"
  }
}