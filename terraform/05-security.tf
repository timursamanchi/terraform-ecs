#######################################
# ECS CLUSTER SECURITY GROUP
#######################################
resource "aws_security_group" "ecs_cluster_sg" {

  name   = "${var.vpc_name}-sg"
  vpc_id = aws_vpc.ecs_vpc.id

  tags = {
    Name = "${var.vpc_name}-sg"
  }
}

resource "aws_security_group_rule" "ecs_ssh_in" {
  # Allows SSH (port 22) inbound to ecs cluster, only from your IP
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.allowed_ssh_cidr] # Now using variable for flexibility
  security_group_id = aws_security_group.ecs_cluster_sg.id
}

resource "aws_security_group_rule" "ecs_http_in" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [var.allowed_ssh_cidr] # Now using variable for flexibility
  security_group_id = aws_security_group.ecs_cluster_sg.id
  description       = "Allow HTTP traffic from anywhere"
}

resource "aws_security_group_rule" "ecs_https_in" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.allowed_ssh_cidr] # Now using variable for flexibility
  security_group_id = aws_security_group.ecs_cluster_sg.id
  description       = "Allow HTTPS traffic from anywhere"
}

resource "aws_security_group_rule" "ecs_all_out" {
  # Allows all outbound traffic from ecs cluster (e.g., to ALB, internet,..etc)
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_cluster_sg.id
}