output "subnet_ids" {
  description = "IDs of subnet"
  value       = aws_subnet.subnet[*].id
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.vpc.id
}