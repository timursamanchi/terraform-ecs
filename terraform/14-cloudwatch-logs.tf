resource "aws_cloudwatch_log_group" "quote_backend_logs" {
  name              = "/ecs/quote-backend"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "quote_frontend_logs" {
  name              = "/ecs/quote-frontend"
  retention_in_days = 7
}

