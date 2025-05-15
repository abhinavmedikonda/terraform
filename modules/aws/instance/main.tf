resource "aws_instance" "app_server" {
  ami           = data.aws_ssm_parameter.ec2-ami.value # Match the data below.
  instance_type = var.instance_type                    # Variable for reusability.
  subnet_id     = var.subnet_id                        # Variable for reusability.
  count         = var.instance_count                   # Variable for reusability
}

data "aws_ssm_parameter" "ec2-ami" {
  # Instead of a specific AMI id, query for the latest.
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}