# Below code was consulted in online documentation.check name

resource aws_vpc instance_vpc { # Could be named main, bla, or anything instead of instance_vpc.
  cidr_block = var.vpc_cidr_block
}

resource aws_subnet instance_subnet { # Arbitrary name instance_subtype or something else instead.
  vpc_id            = aws_vpc.instance_vpc.id
  availability_zone = var.az
  cidr_block        = var.subnet_cidr_block
}

resource aws_internet_gateway instance_igw {
  vpc_id = aws_vpc.instance_vpc.id
}

resource aws_route_table instance_rt {
  vpc_id = aws_vpc.instance_vpc.id
  route {
    cidr_block = "0.0.0.0/0" # Should have been a variable.
    gateway_id = aws_internet_gateway.instance_igw.id
  }
}