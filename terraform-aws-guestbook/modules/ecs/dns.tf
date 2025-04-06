# Create a new Route 53 hosted zone if requested
resource "aws_route53_zone" "new" {
  count = var.create_route53_zone ? 1 : 0
  name  = var.domain_name
}

# Use either the new zone or an existing one
data "aws_route53_zone" "selected" {
  count = var.domain_name != null ? 1 : 0
  zone_id = var.route53_zone_id != null ? var.route53_zone_id : aws_route53_zone.new[0].zone_id
}

# Create DNS record if domain name is provided
resource "aws_route53_record" "root" {
  count = var.domain_name != null ? 1 : 0
  zone_id = data.aws_route53_zone.selected[0].zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_alb.guestbook.dns_name
    zone_id               = aws_alb.guestbook.zone_id
    evaluate_target_health = true
  }
}
