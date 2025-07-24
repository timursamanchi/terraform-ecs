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
  # Allows SSH (port 22) inbound to ecs cluster, only from var.allowed_ingress_cidr
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ingress_cidr # Now using variable for flexibility
  security_group_id = aws_security_group.ecs_cluster_sg.id
}

resource "aws_security_group_rule" "ecs_http_in" {
  # Allows http (port 80) inbound to ecs cluster, only from var.allowed_ingress_cidr
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ingress_cidr # Now using variable for flexibility
  security_group_id = aws_security_group.ecs_cluster_sg.id
  description       = "Allow HTTP traffic from anywhere"
}

resource "aws_security_group_rule" "ecs_https_in" {
  # Allows https (port 443) inbound to ecs cluster, only from var.allowed_ingress_cidr
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ingress_cidr # Now using variable for flexibility
  security_group_id = aws_security_group.ecs_cluster_sg.id
  description       = "Allow HTTPS traffic from anywhere"
}

resource "aws_security_group_rule" "ecs_backend_in" {
  # required for backend tests
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.ecs_vpc.cidr_block]
  security_group_id = aws_security_group.ecs_cluster_sg.id
  description       = "Allow backend traffic from VPC"
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

       "arn:aws:ecs:eu-west-1:040929397520:task/ecs-test-deplyment-cluster/59a521e058eb4f7f815a6934f8912ec7",
        "arn:aws:ecs:eu-west-1:040929397520:task/ecs-test-deplyment-cluster/62221aa3f84a4cb596ece446491f3b22"

aws ecs describe-tasks \
  --cluster ecs-test-deplyment-cluster \
  --tasks arn:aws:ecs:eu-west-1:040929397520:task/ecs-test-deplyment-cluster/62221aa3f84a4cb596ece446491f3b22 \
  --query "tasks[0].attachments[0].details[?name=='publicIPv4Address'].value" \
  --output text

aws ec2 describe-network-interfaces \
  --network-interface-ids eni-006eed2fea3835bcf \
  --query "NetworkInterfaces[0].Association.PublicIp" \
  --output text
