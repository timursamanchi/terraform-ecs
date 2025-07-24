# resource "null_resource" "ecs_health_test" {
#   depends_on = [
#     aws_ecs_service.quote_backend_service,
#     aws_ecs_service.quote_frontend_service
#   ]

#   triggers = {
#     backend_task_def  = aws_ecs_task_definition.quote_backend.revision
#     frontend_task_def = aws_ecs_task_definition.quote_frontend.revision
#   }

#   provisioner "local-exec" {
#     command = "../scripts/healthcheck-test.sh"
#   }
# }
