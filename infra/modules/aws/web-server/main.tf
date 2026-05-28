locals {
  key_name = format("%s-vpn-key-pair", var.env)
  tags = {
    env = var.env
    app = "vpn"
  }

  zone = "eu-west-1a"
}

data "aws_ami" "open_vpn" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["OpenVPN Access Server Community*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

data "external" "whoami" {
  program = ["sh", "-c", "echo '{\"user\": \"'$(whoami)'\"}'"]
}

locals {
  private_key_path = "/home/${data.external.whoami.result.user}/.ssh/${local.key_name}"
}

resource "local_file" "save_key_locally" {
  content         = tls_private_key.rsa.private_key_pem
  filename        = local.private_key_path
  file_permission = "0600"
}

resource "aws_key_pair" "deploy" {
  key_name   = local.key_name
  public_key = tls_private_key.rsa.public_key_openssh
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

resource "aws_instance" "vpn" {
  ami                     = data.aws_ami.open_vpn.id
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
      source   = "82.0.0.0/8"
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
