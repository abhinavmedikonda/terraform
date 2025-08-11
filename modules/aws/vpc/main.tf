resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  assign_generated_ipv6_cidr_block = true
}

resource "aws_subnet" "subnet" {
  count             = var.zones_count
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.azs[count.index]
  cidr_block        = var.subnet_cidr_blocks[count.index]
  ipv6_cidr_block   = cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, count.index) # Assigns an IPv6 CIDR to the subnet
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "subnet_route_table" {
  count          = var.zones_count
  subnet_id      = aws_subnet.subnet[count.index].id
  route_table_id = aws_route_table.route_table.id
}
