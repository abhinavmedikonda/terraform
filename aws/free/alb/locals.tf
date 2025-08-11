locals {
  instance_type    = "t2.micro"
  location         = "us-east-1"
  desired_capacity = 2
  min_size         = 1
  max_size         = 3
}