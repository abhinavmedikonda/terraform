resource "aws_instance" "app_server" {
  ami           = data.aws_ssm_parameter.ec2-ami.value # Match the data below.
  instance_type = var.instance_type                    # Variable for reusability.
  subnet_id     = var.subnet_id                        # Variable for reusability.
  count         = var.instance_count                   # Variable for reusability

  user_data = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
echo '<html><head><title>Taco Team Server</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">You did it! Have a &#127790;</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html
EOF
}

data "aws_ssm_parameter" "ec2-ami" {
  # Instead of a specific AMI id, query for the latest.
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}