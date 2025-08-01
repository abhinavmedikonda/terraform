locals {
  # cwd           = reverse(split("/", path.cwd))
  # instance_type = local.cwd[1]
  # location      = local.cwd[2]
  # environment   = local.cwd[3]
  instance_type = "t2.micro"
  location      = "us-east-1"
  environment   = "free"
}

output "configurations" {
  value = {
    path          = path.cwd
    instance_type = local.instance_type
    location      = local.location
    environment   = local.environment
  }
}

module "instance" {

  source         = "github.com/abhinavmedikonda/terraform//modules/aws/instance?ref=main"
  instance_type  = local.instance_type
  instance_count = 2
  subnet_id      = module.vpc.subnet_id
}

module "vpc" {
  source            = "github.com/abhinavmedikonda/terraform//modules/aws/vpc?ref=main"
  az                = var.az
  vpc_cidr_block    = var.vpc_cidr_block
  subnet_cidr_block = var.subnet_cidr_block
}
