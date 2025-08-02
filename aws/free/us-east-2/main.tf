# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = ">= 3.37.0"
#     }
#   }

#   backend "remote" {
#     # Update to your Terraform Cloud organization
#     organization = "abhinavmedikonda-terraform"

#     workspaces {
#       name = "ec2-deployment"
#     }
#   }
# }

# provider "aws" {
#   region = local.location
# }

# locals {
#   # cwd           = reverse(split("/", path.cwd))
#   # instance_type = local.cwd[1]
#   # location      = local.cwd[2]
#   # environment   = local.cwd[3]
#   instance_type = "t2.micro"
#   location      = "us-east-2"
#   environment   = "aws-free"
# }

# output "configurations" {
#   value = {
#     path          = path.cwd
#     instance_type = local.instance_type
#     location      = local.location
#     environment   = local.environment
#   }
# }

# module "instance" {

#   source         = "github.com/abhinavmedikonda/terraform//modules/aws/instance?ref=main"
#   instance_type  = local.instance_type
#   instance_count = 1
#   subnet_id      = module.vpc.subnet_id
# }
