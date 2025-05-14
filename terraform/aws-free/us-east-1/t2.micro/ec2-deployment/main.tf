# Two blocks:

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
  cwd           = reverse(split("/", path.cwd))
  instance_type = local.cwd[1] # i.e.: The 't2_macro' directory.
  location      = local.cwd[2] # i.e.: 'us-east-1'
  environment   = local.cwd[3] # i.e.: 'aws-free'
}

module "instance" {
  source         = "../../../../../modules/aws/instance"
  instance_type  = local.instance_type
  instance_count = 2
  subnet_id      = module.vpc.subnet_id
}

module "vpc" {
  source            = "../../../../../modules/aws/vpc"
  az                = var.az
  vpc_cidr_block    = var.vpc_cidr_block
  subnet_cidr_block = var.subnet_cidr_block
}
