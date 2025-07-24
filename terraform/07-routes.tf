#######################################
# Public Subnets Route Table and route table association
#######################################
resource "aws_route_table" "public" {
  # Route table for public subnets: routes 0.0.0.0/0 via internet gateway
  vpc_id = aws_vpc.ecs_vpc.id
  tags = {
    Name = "${var.vpc_name}-route-table"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs-gateway.id
  }
}

resource "aws_route_table_association" "public" {
  # Associates public subnets with the public route table
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}