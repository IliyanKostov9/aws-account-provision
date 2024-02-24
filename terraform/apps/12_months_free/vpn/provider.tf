terraform {
  cloud {
    organization = "iliyangit-personal-tf-org"

    workspaces {
      name = "github-aws-account-creation-actions-workspace"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region

}
