#---<root>/dev/us-east-1/t2.micro/ec2-deployment/outputs.tf---#

output "instance_id" {
  description = "ID of the instance"
  value       = module.instance.instance_id[*]
}