data "aws_route53_zone" "minesweeple" {
  name = "minesweeple.com"
}

resource "aws_route53_record" "root" {
  zone_id = data.aws_route53_zone.minesweeple.zone_id
  name    = "minesweeple.com"
  type    = "A"

  alias {
    name                   = aws_alb.guestbook.dns_name
    zone_id               = aws_alb.guestbook.zone_id
    evaluate_target_health = true
  }
}
