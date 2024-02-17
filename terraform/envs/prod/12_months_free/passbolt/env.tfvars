env    = "prod"
region = "eu-west-1"

ec2_name          = "prod-personal-passbolt-ec2-aws"
ec2_ami           = "ami-090387226c863035b"
ec2_instance_type = "t2.micro"
tags = {
  "env"     = "dev"
  "type"    = "personal"
  "service" = "ec2"
  "app"     = "passbolt"
}

