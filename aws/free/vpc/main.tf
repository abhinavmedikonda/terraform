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
  zones_count        = local.zones_count
  vpc_cidr_block     = local.vpc_cidr_block
  azs                = local.azs
  subnet_cidr_blocks = local.subnet_cidr_blocks
  assign_ipv6        = local.assign_ipv6
}

