variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "env" {
  description = "Project environment"
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

