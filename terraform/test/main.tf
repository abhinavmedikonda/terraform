provider "aws" {
  region = "us-east-1" # Choose a region where the S3 Free Tier applies
}

resource "aws_s3_bucket" "test_bucket" {
  bucket = "abhi-terraform-test-bucket"

  tags = {
    Environment = "Test"
    ManagedBy   = "Terraform"
  }
}