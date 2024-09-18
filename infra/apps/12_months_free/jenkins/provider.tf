terraform {
  required_version = "=1.9.5"

  cloud {
    organization = "iliyangit-personal-tf-org"
    workspaces {
      name = "aws-account-provision-jenkins"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.60.0"
    }
  }
}

provider "aws" {
  region = var.region
}
