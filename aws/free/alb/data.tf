data "terraform_remote_state" "vpc" {
  backend = "remote"
  config = {
    organization = "abhinavmedikonda-terraform"
    workspaces = {
      name = "vpc"
    }
  }
}

data "aws_ssm_parameter" "ec2-ami" {
  # Instead of a specific AMI id, query for the latest.
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}
