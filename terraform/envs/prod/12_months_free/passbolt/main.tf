resource "aws_instance" "app_server" {
  ami           = var.ec2_ami
  instance_type = var.ec2_instance_type

  tags = var.tags
}

module "lambda_function_sendgrid" {
  source = "../../always_free/lambda"

}
