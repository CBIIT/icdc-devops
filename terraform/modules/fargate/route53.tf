data "aws_route53_zone" "zone" {
  count = var.create_dns_record ? 1 : 0
  name  = var.domain_name
}

resource "aws_route53_record" "dns_record" {
  count = var.create_dns_record ? 1 : 0
  name = var.app_sub_domain
  type = "A"
  zone_id = data.aws_route53_zone.zone[count.index].zone_id
  alias {
    evaluate_target_health = false
    name = aws_lb.alb.dns_name
    zone_id = aws_lb.alb.zone_id
  }
}
