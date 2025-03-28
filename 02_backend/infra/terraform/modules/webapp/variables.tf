variable "region" {
  type = string
}

variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "whitelist_cidr_blocks" {
  type = list(string)
}

variable "deployer_pubkey" {
  type = string
}
