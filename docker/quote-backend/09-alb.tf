#######################################
# Application Load Balancer
#######################################
resource "aws_lb" "ingress_alb" {
  name                       = "ecs-ingress-alb"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = [aws_subnet.ecs-public.id]  # ✅ no [0] needed
  enable_deletion_protection = false

  tags = {
    Name = "ecs-ingress-alb"
  }
}

#######################################
# Target Group for ECS Frontend
#######################################
resource "aws_lb_target_group" "ingress_tg" {
  name        = "ecs-ingress-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.ecs_vpc.id
  target_type = "ip"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "ecs-ingress-tg"
  }
}

#######################################
# ALB Listener on Port 80
#######################################
resource "aws_lb_listener" "ingress_http" {
  load_balancer_arn = aws_lb.ingress_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ingress_tg.arn
  }
}
