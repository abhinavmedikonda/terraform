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


# module "instance" {
#   source                      = "github.com/abhinavmedikonda/terraform//modules/aws/instance?ref=main"
#   instance_type               = local.instance_type
#   instance_count              = 1
#   subnet_id                   = data.terraform_remote_state.vpc.outputs.subnet_ids[0]
#   associate_public_ip_address = false
# }
