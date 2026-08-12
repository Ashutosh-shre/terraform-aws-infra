resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name       = "ashu-vpc"
    project    = "ashu-terraform"
    managed_by = "terraform"
    owner      = "ashu"
  }
}
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name       = "ashu-public-subnet"
    project    = "ashu-terraform"
    managed_by = "terraform"
    owner      = "ashu"
  }
}
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name       = "ashu-private-subnet"
    project    = "ashu-terraform"
    managed_by = "terraform"
    owner      = "ashu"
  }
}
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name       = "ashu-igw"
    project    = "ashu-terraform"
    managed_by = "terraform"
    owner      = "ashu"
  }
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name       = "ashu-public-rt"
    project    = "ashu-terraform"
    managed_by = "terraform"
    owner      = "ashu"
  }
}
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "main" {
  domain = "vpc"
}
resource "aws_nat_gateway" "main" {
  subnet_id     = aws_subnet.public.id
  allocation_id = aws_eip.main.id
  tags = {
    Name       = "ashu-nat-gateway"
    project    = "ashu-terraform"
    managed_by = "terraform"
    owner      = "ashu"
  }
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
  tags = {
    Name       = "ashu-private-rt"
    project    = "ashu-terraform"
    managed_by = "terraform"
    owner      = "ashu"
  }
}
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
