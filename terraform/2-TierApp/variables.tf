variable "vpc_name" {
  default = "tf-vpc"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "db_name" {
  default = "tfadmin"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  default = "Terraform123!"
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
  default     = "test-key"
}