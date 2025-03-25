locals {
  domain_name = var.domain_name
  sub_domain_name = "sub.${local.domain_name}"
  cdn_domain_name = "cdn.${local.domain_name}"
}
