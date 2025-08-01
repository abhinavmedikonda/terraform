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
      name = "test"
    }
  }
}


provider "aws" {
  region = "us-east-1" # Choose a region where the S3 Free Tier applies
}

resource "aws_s3_bucket" "test_bucket" {
  bucket = "abhinav-terraform-test-bucket"

  tags = {
    Environment = "Test"
    ManagedBy   = "Terraform"
  }
}
