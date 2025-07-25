#######################################
# public subnets for alb and nat-gateway
#######################################
resource "aws_subnet" "ecs-public" {
  vpc_id                  = aws_vpc.ecs_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.ecs_vpc.cidr_block, 4, local.public_subnet_offset)
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "ecs-public-subnet-1"
    AZ   = data.aws_availability_zones.available.names[0]
    Role = "public"
  }
}

#######################################
# Private subnets for ecs cluster
#######################################
resource "aws_subnet" "ecs-private" {
  count             = local.ecs_count
  vpc_id            = aws_vpc.ecs_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.ecs_vpc.cidr_block, 4, count.index + local.private_subnet_offset)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "ecs-priv-subnet-${count.index + 1}"
    AZ   = data.aws_availability_zones.available.names[count.index]
    Role = "private"
  }
}