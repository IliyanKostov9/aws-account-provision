data "aws_route53_zone" "selected" {
  name         = var.top_level_domain
  private_zone = false
}

module "vpn_instance" {
  source             = "../../modules/aws/web-server"
  env                = var.env
  zone_id            = data.aws_route53_zone.selected.zone_id
  domain             = var.vpn_domain
  my_ip              = var.my_ip
  aws_vpn_public_key = var.aws_vpn_public_key
  key_name           = format("%s-vpn-key-pair", var.env)
}

