#######################################
# internet gateway for ecs VPC 
#######################################
resource "aws_internet_gateway" "ecs-gateway" {
  vpc_id = aws_vpc.ecs_vpc.id
  tags = {
    Name = "${var.vpc_name}-gateway"
  }
}