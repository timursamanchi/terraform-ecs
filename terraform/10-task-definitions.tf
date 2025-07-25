#######################################
# ECS Task Definitions - backend
#######################################

resource "aws_ecs_task_definition" "quote_backend" {
  family                   = "quote-backend-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name         = "quote-backend"
      image        = "040929397520.dkr.ecr.eu-west-1.amazonaws.com/quote-backend:v100"
      portMappings = [
        {
          containerPort = 8080
        }
      ]
    }
  ])
}

#######################################
# ECS Task Definitions - backend
#######################################

resource "aws_ecs_task_definition" "quote_frontend" {
  family                   = "quote-frontend-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name         = "quote-frontend"
      image        = "040929397520.dkr.ecr.eu-west-1.amazonaws.com/quote-frontend:v100"
      portMappings = [
        {
          "containerPort": 80,
          "hostPort": 80,
          "protocol": "tcp"
        }
      ]
    }
  ])
}



