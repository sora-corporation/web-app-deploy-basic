resource "aws_route53_zone" "root" {
  name = local.domain_name
}

resource "aws_route53_record" "sub" {
  zone_id = aws_route53_zone.root.zone_id
  name    = local.sub_domain_name
  type    = "A"

  alias {
    name    = aws_lb.webapp.dns_name
    zone_id = aws_lb.webapp.zone_id

    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cdn" {
  zone_id = aws_route53_zone.root.zone_id
  name    = local.cdn_domain_name
  type    = "A"

  alias {
    name    = aws_cloudfront_distribution.main.domain_name
    zone_id = aws_cloudfront_distribution.main.hosted_zone_id

    evaluate_target_health = true
  }
}