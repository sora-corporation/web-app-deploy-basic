resource "aws_route53_zone" "root" {
  name = local.domain_name
}

resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.root.zone_id
  name    = local.api_domain_name
  type    = "A"

  alias {
    name    = aws_lb.webapp.dns_name
    zone_id = aws_lb.webapp.zone_id

    evaluate_target_health = true
  }
}