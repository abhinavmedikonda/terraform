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
  source             = "github.com/abhinavmedikonda/terraform//modules/aws/vpc?ref=main"
  total              = var.total
  vpc_cidr_block     = var.vpc_cidr_block
  azs                = var.azs
  subnet_cidr_blocks = var.subnet_cidr_blocks
}