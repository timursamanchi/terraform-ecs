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


# aws ecs list-tasks \
#   --cluster ecs-test-deplyment-cluster \
#   --desired-status RUNNING

{
    "taskArns": [
        "arn:aws:ecs:eu-west-1:040929397520:task/ecs-test-deplyment-cluster/eec7294c85e441e6ab6bfce9441829b4",
        "arn:aws:ecs:eu-west-1:040929397520:task/ecs-test-deplyment-cluster/f579427f71da4d0e9cf60fd17275a207"
    ]
}

aws ecs describe-tasks \
  --cluster ecs-test-deplyment-cluster \
  --tasks arn:aws:ecs:eu-west-1:040929397520:task/ecs-test-deplyment-cluster/eec7294c85e441e6ab6bfce9441829b4 \
  --query "tasks[0].attachments[0].details[?name=='publicIPv4Address'].value" \
  --output text


aws ecs describe-tasks \
  --cluster ecs-test-deplyment-cluster \
  --tasks <your-task-id> \
  --query "tasks[0].attachments[0].details[?name=='publicIPv4Address'].value" \
  --output text
