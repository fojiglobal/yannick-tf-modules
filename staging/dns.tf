resource "aws_route53_record" "staging" {
  zone_id = var.dns_zone #data.aws_route53_zone.yanapps.zone_id
  name    = var.dns_name #"stage.yannick.com"
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = false
  }
}