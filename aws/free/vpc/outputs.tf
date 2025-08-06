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
    pd1  = local.cwd[1]
    pd2  = local.cwd[2]
    pd3  = local.cwd[3]
  }
}
