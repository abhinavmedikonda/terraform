output "subnet_ids" {
  description = "IDs of subnet"
  value       = module.vpc.subnet_ids
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "path" {
  value = {
    path = path.cwd
    pp1  = local.cwd[1]
    pp2  = local.cwd[2]
    pp3  = local.cwd[3]
  }
}
