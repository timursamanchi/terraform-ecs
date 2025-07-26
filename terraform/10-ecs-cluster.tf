#######################################
# ECS cluster creation
#######################################
resource "aws_ecs_cluster" "quote_cluster" {
  name = "${var.vpc_name}-cluster"

  tags = {
    Name = "${var.vpc_name}-cluster"
  }
}

