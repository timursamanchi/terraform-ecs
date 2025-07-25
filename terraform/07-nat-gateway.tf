#######################################
# Elastic IP for NAT Gateway
#######################################
resource "aws_eip" "nat_eip" {
  tags = {
    Name = "${var.vpc_name}-nat-eip"
  }
}

#######################################
# NAT Gateway in the public subnet
#######################################
resource "aws_nat_gateway" "ecs_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.ecs-public.id  # ✅ no [0] since it's not a count-based resource

  tags = {
    Name = "ecs-nat-gateway"
  }

  depends_on = [aws_internet_gateway.ecs-gateway]
}
