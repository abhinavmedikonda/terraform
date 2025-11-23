terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.37.0"
    }
  }

  backend "remote" { # TerraformCloud takes care of locking backend for concurrency.
    organization = "abhinavmedikonda-terraform"
    workspaces {
      name = "alb"
    }
  }
}

provider "aws" {
  region = local.location
}
