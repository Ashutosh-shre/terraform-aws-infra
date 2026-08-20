resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = merge(local.common_tags, {
    Name = "${local.project}-vpc"
  })

}
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnets["public"].cidr_block
  availability_zone = var.subnets["public"].availability_zone
  tags = merge(local.common_tags, {
    Name = "${local.project}-public-subnet"
  })
}
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnets["private"].cidr_block
  availability_zone = var.subnets["private"].availability_zone
  tags = merge(local.common_tags, {
    Name = "${local.project}-private-subnet"
  })
}
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(local.common_tags, {
    Name = "${local.project}-internet-gateway"
  })
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = var.route_cidr
    gateway_id = aws_internet_gateway.main.id
  }
  tags = merge(local.common_tags, {
    Name = "${local.project}-public-rt"
  })
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
  tags = merge(local.common_tags, {
    Name = "${local.project}-nat-gateway"
  })
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = var.route_cidr
    nat_gateway_id = aws_nat_gateway.main.id
  }
  tags = merge(local.common_tags, {
    Name = "${local.project}-private-rt"
  })
}
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
