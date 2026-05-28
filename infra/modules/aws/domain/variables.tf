variable "env" {
  description = "Environment of the VPN"
  type        = string
}

variable "zone_id" {
  description = "Zone ID for the domain"
  type        = string
}

variable "top_level_domain" {
  description = "Top level domain"
  type        = string
}

variable "route53_records" {
  description = "Route53 records"
  type = map(object({
    subdomain = string
    type      = string
    value     = list(string)
  }))
}

