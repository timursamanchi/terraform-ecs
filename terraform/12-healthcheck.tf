resource "null_resource" "ecs_health_test" {
    
  depends_on = [
    aws_ecs_service.quote_backend_service,
    aws_ecs_service.quote_frontend_service
  ]

  provisioner "local-exec" {
    command = "./scripts/test-ecs-health.sh"
  }
}
