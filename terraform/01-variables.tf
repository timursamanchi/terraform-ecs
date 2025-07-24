# variables
#######################################
# AWS Region
#######################################
variable "aws_region" {
  description = "select aws region"
  type        = string
  default     = "eu-west-1"
}

#######################################
# VPC Configuration
#######################################
variable "vpc_name" {
  description = "project VPC name"
  type        = string
  default     = "test-only"
}

variable "ecs_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

#######################################
# ecs cluster configuration
#######################################
variable "ecs_cluster_count" {
  description = "Number of ecs clusters"
  type        = number
  default     = 1
}

#######################################
# Ingress Access Configuration
#######################################
variable "allowed_ingress_cidr" {
  description = "The CIDR block allowed to SSH, HTTP and HTTPS access"
  type        = string
  default     = ["0.0.0.0/0"] # ⚠ TEMPORARY — update before production. 
}
#######################################