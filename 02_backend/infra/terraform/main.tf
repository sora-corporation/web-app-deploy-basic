
variable "domain_name" {}
variable "whitelist_cidr_blocks" {}
variable "deployer_pubkey" {}

terraform {
  required_version = "1.11.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.92.0"
    }
  }

  backend "s3" {
    bucket  = "web-app-deploy-basic-day2-terraform-state"
    region  = "ap-northeast-1"
    key     = "web-app-deploy-basic.terraform.tfstate"
    encrypt = true
    profile = "web-app-deploy-basic"
  }
}

provider "aws" {
  region  = var.region
  profile = "web-app-deploy-basic"
  default_tags {
    tags = {
      project     = var.project
      environment = var.environment
    }
  }
}

provider "aws" {
  alias   = "virginia"
  region  = "us-east-1"
  profile = "web-app-deploy-basic"
  default_tags {
    tags = {
      project     = var.project
      environment = var.environment
    }
  }
}

module "webapp" {
  source = "./modules/webapp"
  providers = {
    aws          = aws
    aws.virginia = aws.virginia
  }
  region      = var.region
  project     = var.project
  environment = var.environment

  domain_name           = var.domain_name
  whitelist_cidr_blocks = var.whitelist_cidr_blocks
  deployer_pubkey       = var.deployer_pubkey
}
