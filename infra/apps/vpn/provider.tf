terraform {
  required_version = ">= 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.41"
    }
  }

  backend "s3" {
    bucket = "tf-state-aws-944850789927"
    key    = "states/aws-account-provision/prod/vpn/terraform.tfstate"
    region = "eu-west-1"

    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}
