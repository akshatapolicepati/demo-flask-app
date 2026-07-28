data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc-tf" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-vpc"
    }
  )
}

resource "aws_internet_gateway" "vpc-tf" {
  vpc_id = aws_vpc.vpc-tf.id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-igw"
    }
  )
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.vpc-tf.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-public-a"
    }
  )
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.vpc-tf.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-public-b"
    }
  )
}

resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.vpc-tf.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-public-c"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc-tf.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-tf.id
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-public-rt"
    }
  )
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public.id
}