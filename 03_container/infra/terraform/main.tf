
variable "domain_name" {}

terraform {
  required_version = "1.11.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.92.0"
    }
  }

  backend "s3" {
    bucket = "web-app-deploy-basic-day3-terraform-state"

    region = "ap-northeast-1"
    key    = "web-app-deploy-basic.terraform.tfstate"

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

module "webapp" {
  source      = "./modules/webapp"
  region      = var.region
  project     = var.project
  environment = var.environment

  domain_name = var.domain_name
}
