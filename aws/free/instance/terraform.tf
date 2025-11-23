# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = ">= 3.37.0"
#     }
#   }

#   backend "remote" {
#     organization = "abhinavmedikonda-terraform"
#     workspaces {
#       name = "instance"
#     }
#   }
# }

# provider "aws" {
#   region = local.location
# }
