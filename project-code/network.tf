

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = merge(local.common_tags, {
    Name = "${local.project}-vpc"
  })

  lifecycle {
    precondition {
      condition = length(local.public_subnet_indexes) >= length(local.availability_zones)

      error_message = "Number of public subnets must be greater than or equal to the number of availability zones."
    }
  }
}
resource "aws_subnet" "main" {
  count             = length(var.subnet_config)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_config[count.index].cidr_block
  availability_zone = local.availability_zones[count.index % length(local.availability_zones)]
  tags = merge(local.common_tags, {
    Name = "${local.project}-${var.subnet_config[count.index].name}"
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
  count          = length(local.public_subnet_indexes)
  subnet_id      = aws_subnet.main[local.public_subnet_indexes[count.index]].id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "main" {
  count  = length(local.public_subnet_indexes)
  domain = "vpc"
  tags = merge(local.common_tags, {
    Name = "${local.project}-eip-${count.index + 1}"
  })
}
resource "aws_nat_gateway" "main" {
  count         = length(local.availability_zones)
  subnet_id     = aws_subnet.main[local.public_subnet_indexes[count.index]].id
  allocation_id = aws_eip.main[count.index].id
  tags = merge(local.common_tags, {
    Name = "${local.project}-nat-${count.index + 1}"
  })
}
resource "aws_route_table" "private" {
  count  = length(local.availability_zones)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = var.route_cidr
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }
  tags = merge(local.common_tags, {
    Name = "${local.project}-private-rt-${count.index + 1}"
  })
}
resource "aws_route_table_association" "private" {
  count          = length(local.private_subnet_indexes)
  subnet_id      = aws_subnet.main[local.private_subnet_indexes[count.index]].id
  route_table_id = aws_route_table.private[count.index % length(local.availability_zones)].id

}
