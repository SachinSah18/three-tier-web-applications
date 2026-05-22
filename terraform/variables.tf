variable "aws_region" {
  description = "AWS region for local Terraform runs."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Common name prefix for resources."
  type        = string
  default     = "employee-3-tier"
}

variable "db_password" {
  description = "MySQL password for the ECS task environment."
  type        = string
  sensitive   = true
}

variable "container_image" {
  description = "Container image URI from ECR."
  type        = string
  default     = "public.ecr.aws/docker/library/node:20-alpine"
}
