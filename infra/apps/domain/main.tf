module "zone" {
  source           = "../../modules/aws/domain"
  env              = var.env
  top_level_domain = var.top_level_domain
  route53_records  = var.route53_records
}
