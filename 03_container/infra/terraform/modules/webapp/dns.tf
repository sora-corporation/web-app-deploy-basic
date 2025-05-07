resource "aws_route53_zone" "root" {
  name = var.domain_name
}