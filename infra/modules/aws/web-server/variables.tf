variable "env" {
  description = "Environment of the VPN"
  type        = string
}

variable "domain" {
  description = "Domain name for the vpn"
  type        = string
}

variable "zone_id" {
  description = "Zone id"
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

variable "key_name" {
  description = "The key name"
  type        = string
}
