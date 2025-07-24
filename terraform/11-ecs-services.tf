resource "aws_ecs_service" "quote_backend_service" {
  name            = "quote-backend-service"
  cluster         = aws_ecs_cluster.quote_cluster.id
  task_definition = aws_ecs_task_definition.quote_backend.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.public[0].id]
    security_groups  = [aws_security_group.ecs_cluster_sg.id]
    assign_public_ip = true
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role_policy]
}

resource "aws_ecs_service" "quote_frontend_service" {
  name            = "quote-frontend-service"
  cluster         = aws_ecs_cluster.quote_cluster.id
  task_definition = aws_ecs_task_definition.quote_frontend.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.public[0].id]
    security_groups  = [aws_security_group.ecs_cluster_sg.id]
    assign_public_ip = true
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role_policy]
}
