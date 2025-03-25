module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "vpc-${var.project}"
  cidr = "10.0.0.0/16"

  azs                          = ["${var.region}a", "${var.region}c"]
  public_subnets               = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets              = ["10.0.101.0/24", "10.0.102.0/24"]
  create_database_subnet_group = false

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support   = true
}
