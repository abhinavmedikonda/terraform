terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.37.0"
    }
  }

  backend "remote" {
    organization = "abhinavmedikonda-terraform"
    workspaces {
      name = "vpc"
    }
  }
}

provider "aws" {
  region = local.location
}

module "vpc" {
  source            = "github.com/abhinavmedikonda/terraform//modules/aws/vpc?ref=main"
  az                = var.az
  vpc_cidr_block    = var.vpc_cidr_block
  subnet_cidr_block = var.subnet_cidr_block
}