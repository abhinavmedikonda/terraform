locals {
  cwd                = reverse(split("/", path.cwd))
  location           = "us-east-1"
  zones_count        = 2
  vpc_cidr_block     = "10.0.0.0/16"
  azs                = ["us-east-1a", "us-east-1b"]
  subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
  assign_ipv6        = true
}
