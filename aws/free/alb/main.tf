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

data "terraform_remote_state" "vpc" {
  backend = "remote"
  config = {
    organization = "abhinavmedikonda-terraform"
    workspaces = {
      name = "vpc"
    }
  }
}

resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.terraform_remote_state.vpc.outputs.subnet_ids
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

data "aws_ssm_parameter" "ec2-ami" {
  # Instead of a specific AMI id, query for the latest.
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_launch_template" "launch_template" {
  name                   = "launch-template"
  image_id               = data.aws_ssm_parameter.ec2-ami.value
  instance_type          = local.instance_type
  # key_name               = "my-key-pair"
  # vpc_security_group_ids = [aws_security_group.instance_sg.id]
  user_data              = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
echo '<html><head><title>Taco Team Server</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">You did it! Have a &#127790;</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html
EOF
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
