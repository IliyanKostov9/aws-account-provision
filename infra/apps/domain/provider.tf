terraform {
  required_version = ">= 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.41"
    }
  }

  backend "s3" {
    bucket = "tf-state-aws-405466951648"
    key    = "states/prod/domain/terraform.tfstate"
    region = "eu-west-1"

    dynamodb_table = "terraform-state-locks-aws"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}
