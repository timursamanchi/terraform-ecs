#######################################
# public subnets
#######################################

resource "aws_subnet" "public" {
  count                   = local.subnet_count
  vpc_id                  = aws_vpc.ecs_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.ecs_vpc.cidr_block, 4, count.index + local.public_subnet_offset)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "ecs-public-subnet-${count.index + 1}"
    AZ   = data.aws_availability_zones.available.names[count.index]
    Role = "public"
  }
}