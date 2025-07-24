output "ecs_cluster_name" {
  description = "Name of the ECS Cluster"
  value       = aws_ecs_cluster.quote_cluster.name
}

output "quote_backend_service_name" {
  description = "Name of the ECS backend service"
  value       = aws_ecs_service.quote_backend_service.name
}

output "quote_frontend_service_name" {
  description = "Name of the ECS frontend service"
  value       = aws_ecs_service.quote_frontend_service.name
}
