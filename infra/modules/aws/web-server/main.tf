locals {
  tags = {
    env = var.env
    app = "vpn"
  }

  zone = "eu-west-1a"
}

resource "aws_key_pair" "deploy" {
  key_name   = var.key_name
  public_key = var.aws_vpn_public_key
}

resource "aws_ebs_volume" "vpn_volume" {
  availability_zone = local.zone
  size              = 30
  type              = "gp3"
  tags              = local.tags
}

resource "aws_vpc" "vpn_vpc" {
  cidr_block = "172.16.0.0/16"
  tags       = local.tags
}

resource "aws_security_group" "vpn_security_group" {
  name        = format("vpn-security-group-%s", var.env)
  description = format("Security group for VPN in %s environment", upper(var.env))
  vpc_id      = aws_vpc.vpn_vpc.id
  tags        = local.tags
}

resource "aws_subnet" "vpn_subnet" {
  vpc_id            = aws_vpc.vpn_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = local.zone
}

resource "aws_internet_gateway" "vpn_internet" {
  vpc_id = aws_vpc.vpn_vpc.id
  tags   = local.tags
}

resource "aws_route_table" "vpn" {
  vpc_id = aws_vpc.vpn_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpn_internet.id
  }
}

resource "aws_route_table_association" "vpn_associate" {
  subnet_id      = aws_subnet.vpn_subnet.id
  route_table_id = aws_route_table.vpn.id
}


data "aws_ssm_parameter" "openvpn_ami_alias" {
  name = "/aws/service/marketplace/prod-qqrkogtl46mpu/3.2.2a"
}

resource "aws_instance" "vpn" {
  ami                     = data.aws_ssm_parameter.openvpn_ami_alias.value
  subnet_id               = aws_subnet.vpn_subnet.id
  instance_type           = "t2.micro"
  disable_api_termination = false
  key_name                = aws_key_pair.deploy.key_name
  availability_zone       = local.zone
  vpc_security_group_ids = [
    aws_security_group.vpn_security_group.id
  ]
  tags       = local.tags
  depends_on = [aws_internet_gateway.vpn_internet]
}

resource "aws_volume_attachment" "vpn_ebs" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.vpn_volume.id
  instance_id = aws_instance.vpn.id
}

resource "aws_eip" "vpn" {
  instance = aws_instance.vpn.id
  domain   = "vpc"
  tags     = local.tags
}

locals {
  rules = {
    "https-vpn-connect" = {
      port     = 443
      protocol = "tcp"
      source   = format("%s/32", aws_eip.vpn.public_ip)
    }
    "https-connect" = {
      port     = 443
      protocol = "tcp"
    }
    "connections_over_udp" = {
      port     = 1194
      protocol = "udp"
    }
    "ninefourthree" = {
      port     = 943
      protocol = "tcp"
    }
    "http" = {
      port     = 80
      protocol = "tcp"
    }
    "ssh" = {
      port     = 22
      protocol = "tcp"
      source   = format("%s/32", var.my_ip)
    }
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rules" {
  for_each          = local.rules
  security_group_id = aws_security_group.vpn_security_group.id

  cidr_ipv4   = try(each.value.source, "0.0.0.0/0")
  from_port   = each.value.port
  to_port     = each.value.port
  ip_protocol = each.value.protocol
  tags        = local.tags
}

resource "aws_vpc_security_group_egress_rule" "outbound_rule" {
  security_group_id = aws_security_group.vpn_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_route53_record" "vpn" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "A"
  ttl     = 300
  records = [aws_eip.vpn.public_ip]
}
