output "subnet_id" {
  description = "ID of subnet"
  value       = aws_subnet.instance_subnet.id
}

# Necessary to communicate with the root module at <root>/terraform/dev/us-east-1/t2-micro/ec2-deployment/main.tf