variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "nginx-tf-cluster"
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = "nginx-tf-service"
}

variable "task_definition_name" {
  description = "Name of the ECS task definition"
  type        = string
  default     = "nginx-tf-td"
}

variable "vpc_id" {
  description = "ID of the existing VPC"
  type        = string
  default     = "vpc-0b21fcfb221b40abb"
}

variable "subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
  default     = ["subnet-0d4bb03b40c570dd3", "subnet-0cf5f3d31cf07c14b"]
}

variable "nginx_image" {
  description = "Docker image to deploy"
  type        = string
  default     = "nginx:latest"
}
