provider "aws" {
  region = var.region
}
resource "aws_key_pair" "key_name" {
  key_name   = var.key_name_value
  public_key = file("${var.key_path_value}")
}
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_value
  tags = {
    Name = "awsvpc"
  }
}
# Create public subnets
resource "aws_subnet" "public_sub1" {
  count             = 2
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 4, count.index)
  availability_zone = element(var.zone_value, count.index) # Change to your desired availability zone

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}
# Create private subnets
resource "aws_subnet" "private_sub1" {
  count             = 2
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 4, 4 + count.index)
  availability_zone = element(var.zone_value, count.index) # Change to your desired availability zone

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

# resource "aws_subnet" "public_sub1" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = var.cidr_sub1_value
#   availability_zone       = var.zone_value
#   map_public_ip_on_launch = true
# }
# resource "aws_subnet" "private_sub1" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = var.cidr_sub2_value
#   availability_zone       = var.zone2_value
#   map_public_ip_on_launch = true
# }
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}
resource "aws_route_table" "pubRT" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "PublicRT"
  }
}
resource "aws_route_table" "privRT" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "PrivateRT"
  }
}
resource "aws_route_table_association" "rta1" {
  count = 2
  subnet_id      = element(aws_subnet.public_sub1[*].id, count.index)
  route_table_id = aws_route_table.pubRT.id
}
resource "aws_route_table_association" "rta2" {
  count = 2
  subnet_id      = element(aws_subnet.private_sub1[*].id, count.index)
  route_table_id = aws_route_table.privRT.id
}
resource "aws_security_group" "webSg" {
  name = "web"
  vpc_id = aws_vpc.vpc.id
  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "websg"
  }
}
