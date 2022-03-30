
data "aws_route53_zone" "zone" {
  name  = var.domain_name
}

resource "aws_route53_record" "www" {
  count =  terraform.workspace ==  "prod" ? 1 : 0
  name = "www"
  type = "CNAME"
  zone_id = data.aws_route53_zone.zone.zone_id
  ttl = "5"
  records = [var.domain_name]
}

resource "aws_route53_record" "lower_tiers_records" {
  name = var.app_sub_domain
  type = "A"
  zone_id = data.aws_route53_zone.zone.zone_id
  alias {
    evaluate_target_health = false
    name = aws_lb.alb.dns_name
    zone_id = aws_lb.alb.zone_id
  }
}

