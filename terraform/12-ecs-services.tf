#######################################
# ECS Frontend Service (Public, No ALB)
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
    subnets          = [aws_subnet.ecs-public.id]  # Public subnet
    security_groups  = [aws_security_group.ecs_cluster_sg.id]
    assign_public_ip = true
  }

  tags = {
    Name = "quote-frontend-service"
  }

  depends_on = [aws_iam_role.ecs_task_execution_role]
}

#######################################
# ECS Backend Service (Private)
#######################################
resource "aws_ecs_service" "quote_backend_service" {
  name                                = "quote-backend-service"
  cluster                             = aws_ecs_cluster.quote_cluster.id
  task_definition                     = aws_ecs_task_definition.quote_backend.arn
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

  tags = {
    Name = "quote-backend-service"
  }

  depends_on = [aws_iam_role.ecs_task_execution_role]
}
