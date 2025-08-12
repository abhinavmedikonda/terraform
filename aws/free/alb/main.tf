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
  ip_address_type    = "dualstack-without-public-ipv4"
  security_groups    = [aws_security_group.security_group.id]
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
  network_interfaces {
    associate_public_ip_address = false
    ipv6_address_count          = 1
    security_groups             = [aws_security_group.security_group.id]
  }
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

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
IPv6=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/ipv6)

# Create a simple index.html file
echo '<center><h1>Hello from Amazon Linux EC2!</h1></center>' | sudo tee /var/www/html/index.html
echo "<center><h1>IPv6: $IPv6</h1></center>" | sudo tee -a /var/www/html/index.html
EOF
  )
}

resource "aws_autoscaling_group" "example_asg" {
  name                = "asg"
  vpc_zone_identifier = data.terraform_remote_state.vpc.outputs.subnet_ids
  desired_capacity    = local.desired_capacity
  min_size            = local.min_size
  max_size            = local.max_size
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.alb_tg.arn]
}

resource "aws_security_group" "security_group" {
  name        = "security-group"
  description = "security group"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description = "Allow HTTP (IPv4)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow HTTP (IPv6)"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }

  # ingress {
  #   description = "Allow SSH (IPv4)"
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # ingress {
  #   description      = "Allow SSH (IPv6)"
  #   from_port        = 22
  #   to_port          = 22
  #   protocol         = "tcp"
  #   ipv6_cidr_blocks = ["::/0"]
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound IPv4 traffic"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
    description      = "Allow all outbound IPv6 traffic"
  }
}
