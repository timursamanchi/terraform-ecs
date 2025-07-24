resource "aws_ecs_task_definition" "quote_backend" {
  family                   = "quote-backend-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "quote-backend"
      image = "040929397520.dkr.ecr.eu-west-1.amazonaws.com/aws-quote-backend:latest"
      portMappings = [
        {
          containerPort = 8080
        }
      ]
    }
  ])
}

resource "aws_ecs_task_definition" "quote_frontend" {
  family                   = "quote-frontend-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "quote-frontend"
      image = "040929397520.dkr.ecr.eu-west-1.amazonaws.com/aws-quote-frontend:latest"
      portMappings = [
        {
          containerPort = 80
        }
      ]
    }
  ])
}
