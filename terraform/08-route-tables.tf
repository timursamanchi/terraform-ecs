#######################################
# Public Subnet Route Table and Association
#######################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.ecs_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs-gateway.id
  }

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.ecs-public.id
  route_table_id = aws_route_table.public.id
}

#######################################
# Private Subnets Route Table and Associations
#######################################

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.ecs_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ecs_nat.id
  }

  tags = {
    Name = "${var.vpc_name}-private-route-table"
  }
}

resource "aws_route_table_association" "controller_priv" {
  count          = length(aws_subnet.ecs-private)
  subnet_id      = aws_subnet.ecs-private[count.index].id  # ✅ indexed private subnets
  route_table_id = aws_route_table.private.id
}
