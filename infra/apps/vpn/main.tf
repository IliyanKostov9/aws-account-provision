module "vpn_instance" {
  source  = "../../modules/aws/web-server"
  env     = var.env
  zone_id = var.zone_id
  domain  = var.vpn_domain
}
#
# module "zone" {
#   source           = "../../modules/aws/domain"
#   env              = var.env
#   zone_id          = var.zone_id
#   top_level_domain = var.top_level_domain
#   route53_records  = var.route53_records
# }
