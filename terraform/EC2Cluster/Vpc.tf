# Create VPC
resource "aws_vpc" "devops_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.devops_vpc.id
}

# Create a primary public subnet (for instances)
resource "aws_subnet" "primary" {
  vpc_id                  = aws_vpc.devops_vpc.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = var.primary_az
  map_public_ip_on_launch = true
}

# Create a secondary public subnet (for ALB)
resource "aws_subnet" "secondary" {
  vpc_id                  = aws_vpc.devops_vpc.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = var.secondary_az
  map_public_ip_on_launch = true
}

# Create Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.devops_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Associate route table with primary subnet
resource "aws_route_table_association" "primary" {
  subnet_id      = aws_subnet.primary.id
  route_table_id = aws_route_table.public.id
}

# Associate route table with secondary subnet
resource "aws_route_table_association" "secondary" {
  subnet_id      = aws_subnet.secondary.id
  route_table_id = aws_route_table.public.id
}