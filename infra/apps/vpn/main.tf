module "vpn_instance" {
  source  = "../../modules/aws/web-server"
  env     = var.env
  zone_id = var.zone_id
  domain  = var.vpn_domain
}

import {
  to = module.vpn_instance.aws_key_pair.deploy
  id = format("%s-vpn-key-pair", var.env)
}

resource "aws_route53_zone" "primary" {
  name = "ikostov.org"
}

import {
  to = aws_route53_zone.primary
  id = var.zone_id
}

module "zone" {
  source           = "../../modules/aws/domain"
  env              = var.env
  zone_id          = var.zone_id
  top_level_domain = var.top_level_domain
  route53_records  = var.route53_records
}
