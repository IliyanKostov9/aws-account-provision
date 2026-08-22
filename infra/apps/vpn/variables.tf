variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "env" {
  description = "Project environment"
  type        = string
}

variable "vpn_domain" {
  description = "VPN domain"
  type        = string
}

variable "top_level_domain" {
  description = "Top level domain"
  type        = string
}

variable "my_ip" {
  description = "My ip"
  type        = string
}

variable "aws_vpn_public_key" {
  description = "The public key for the ec2 instance"
  type        = string
}




