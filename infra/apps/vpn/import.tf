resource "aws_route53_zone" "main" {
  name = var.top_level_domain
  tags = {
    env = var.env
  }
}

import {
  to = aws_route53_zone.main
  id = var.zone_id
}

