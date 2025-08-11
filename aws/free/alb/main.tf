terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.37.0"
    }
  }

  backend "remote" {
    organization = "abhinavmedikonda-terraform"
    workspaces {
      name = "alb"
    }
  }
}

provider "aws" {
  region = local.location
}


resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.terraform_remote_state.vpc.outputs.subnet_ids
  ip_address_type    = "dualstack"
  # security_groups    = [aws_security_group.alb_sg.id]
}

resource "aws_lb_target_group" "alb_tg" {
  name     = "target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.vpc_id
  health_check {
    path = "/"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}


# ssh-keygen -t rsa -b 4096 -f ~/.ssh/key-pair.pem
resource "aws_key_pair" "key_pair" {
  key_name   = "key-pair"
  public_key = file("key-pair.pub")
}

resource "aws_launch_template" "launch_template" {
  name          = "launch-template"
  image_id      = data.aws_ssm_parameter.ec2-ami.value
  instance_type = local.instance_type
  key_name      = aws_key_pair.key_pair.key_name
  # vpc_security_group_ids = [aws_security_group.instance_sg.id]
  user_data = base64encode(<<EOF
#!/bin/bash
# Update the system
sudo yum update -y

# Install Apache web server
sudo yum install -y httpd

# Start Apache and enable it to start on boot
sudo systemctl start httpd
sudo systemctl enable httpd

# Create a simple index.html file
echo '<h1>Hello from Amazon Linux EC2!</h1>' | sudo tee /var/www/html/index.html
EOF
  )
}

resource "aws_autoscaling_group" "example_asg" {
  name                = "asg"
  vpc_zone_identifier = data.terraform_remote_state.vpc.outputs.subnet_ids
  desired_capacity    = 2
  min_size            = 1
  max_size            = 3
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.alb_tg.arn]
}
