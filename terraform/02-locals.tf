#######################################
# locals to place subnets evenly across AZs
#######################################

locals {
  ecs_count    = var.ecs_cluster_count
  az_count     = length(data.aws_availability_zones.available.names)
  subnet_count = min(local.ecs_count, local.az_count)

  # Optional offsets
  public_subnet_offset  = 0
  private_subnet_offset = local.subnet_count
}
