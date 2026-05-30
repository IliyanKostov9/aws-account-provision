resource "aws_route53_zone" "main" {
  name = var.top_level_domain
  tags = {
    env = var.env
  }
}

resource "aws_route53_record" "records" {
  for_each = var.route53_records
  zone_id  = aws_route53_zone.main.id
  name     = format("%s.%s", each.value.subdomain, var.top_level_domain)
  type     = each.value.type
  ttl      = 300
  records  = each.value.value
}
