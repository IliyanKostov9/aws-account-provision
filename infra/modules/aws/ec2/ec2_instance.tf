resource "aws_key_pair" "key_pair" {
  key_name   = var.ec2_key_pair_name
  public_key = var.ec2_key_pair_public_key

}

resource "aws_instance" "app_server" {

  ami                         = var.ec2_ami
  key_name                    = aws_key_pair.key_pair.id
  instance_type               = var.ec2_instance_type
  vpc_security_group_ids      = [aws_security_group.http_server_sg.id]
  subnet_id                   = tolist(data.aws_subnets.default_subnets.ids)[0]
  associate_public_ip_address = true
  tags                        = var.ec2_tags
  depends_on                  = [aws_key_pair.key_pair]

  connection {
    type  = "ssh"
    host  = self.public_ip
    user  = "ubuntu"
    agent = false

    # TODO: Require the agent to have private key id_rsa in this path
    private_key = file("${path.module}/id_rsa")
  }

  lifecycle {
    prevent_destroy = true
  }

  provisioner "remote-exec" {
    inline = var.ec2_remote_exec_commands
  }
}
