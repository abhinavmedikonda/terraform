terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.37.0"
    }
  }

  backend "remote" {
    # Update to your Terraform Cloud organization
    organization = "abhinavmedikonda-terraform"

    workspaces {
      name = "ec2-deployment"
    }
  }
}

provider "aws" {
  region = local.location
}

locals {
	location = "us-east-1"
}