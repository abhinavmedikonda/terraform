# Terraform AWS ALB with IPv6-Only EC2 Autoscaling

This repository contains Terraform code to deploy an AWS Application Load Balancer (ALB) with an Auto Scaling Group of EC2 instances that have **only public IPv6 addresses** (no public IPv4). The infrastructure is modular and uses remote state for VPC networking.

## Features

- **VPC and Subnets**: Created via a reusable module, supporting dual-stack (IPv4/IPv6) networking.
- **Application Load Balancer (ALB)**: Dualstack, but configured to not assign public IPv4 addresses.
- **Auto Scaling Group**: Launches EC2 instances with only IPv6 public addresses.
- **Security Groups**: Allow HTTP (port 80) access over both IPv4 and IPv6.
- **Launch Template**: No SSH keypair by default (can be enabled if needed), no public IPv4, assigns IPv6.
- **Remote State**: Uses Terraform Cloud/Enterprise for state management.

## Usage

1. **Clone the repository:**
   ```sh
   git clone https://github.com/your-username/terraform-aws-alb-ipv6.git
   cd terraform-aws-alb-ipv6
   ```

2. **Configure variables:**
   - Edit `variables.tf` and provide your desired values for VPC CIDR, subnets, AZs, etc.

3. **Initialize Terraform:**
   ```sh
   terraform init
   ```

4. **Plan and apply:**
   ```sh
   terraform plan
   terraform apply
   ```

## Structure

- `modules/aws/vpc/` - VPC and subnet module.
- `aws/free/alb/main.tf` - Main ALB, ASG, and EC2 resources.
- `.gitignore` - Standard Terraform and OS ignores.

## Notes

- **No public IPv4**: EC2 instances will only have IPv6 public addresses.
- **SSH Access**: Disabled by default. To enable, uncomment the SSH ingress rules and provide a keypair.
- **Remote State**: Update the backend configuration to match your Terraform Cloud/Enterprise workspace.

## Requirements

- Terraform >= 1.0
- AWS provider >= 3.37.0
- AWS account with appropriate permissions

## License

MIT License