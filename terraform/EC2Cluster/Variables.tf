variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for primary public subnet where instances will be deployed"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for secondary subnet (for ALB only, no instances)"
  type        = string
  default     = "10.0.2.0/24"
}

variable "primary_az" {
  description = "Availability zone for all instances"
  type        = string
  default     = "eu-central-1a"
}

variable "secondary_az" {
  description = "Secondary availability zone (for ALB only, no instances)"
  type        = string
  default     = "eu-central-1b"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of SSH key pair"
  type        = string
  default     = "test-key"
}

variable "instance_count" {
  description = "Number of EC2 instances to launch"
  type        = number
  default     = 3
}