#######################################
# ECS Backend Service (private)
#######################################
resource "aws_ecs_service" "quote_frontend_service" {
  name                                = "quote-frontend-service"
  cluster                             = aws_ecs_cluster.quote_cluster.id
  task_definition                     = aws_ecs_task_definition.quote_frontend.arn
  desired_count                       = 1
  launch_type                         = "FARGATE"
  scheduling_strategy                 = "REPLICA"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  network_configuration {
    subnets          = [aws_subnet.ecs-public.id]
    security_groups  = [aws_security_group.ecs_cluster_sg.id]
    assign_public_ip = true
  }

  tags = {
    Name = "quote-frontend-service"
  }

  depends_on = [aws_iam_role.ecs_task_execution_role]
}

#######################################
# ECS Frontend Service (public via ALB)
#######################################
resource "aws_ecs_service" "quote_frontend_service" {
  name                                = "quote-frontend-service"
  cluster                             = aws_ecs_cluster.quote_cluster.id
  task_definition                     = aws_ecs_task_definition.quote_frontend.arn
  desired_count                       = 1
  launch_type                         = "FARGATE"
  scheduling_strategy                 = "REPLICA"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  network_configuration {
    subnets          = aws_subnet.ecs-private[*].id
    security_groups  = [aws_security_group.ecs_cluster_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ingress_tg.arn
    container_name   = "quote-frontend"
    container_port   = 80
  }

  depends_on = [
    aws_lb_listener.ingress_http,
    aws_iam_role.ecs_task_execution_role
  ]

  tags = {
    Name = "quote-frontend-service"
  }
}
