variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "lambda_name" {
  description = "Lambda function name"
  type        = string
  default     = "testDataFunction2"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  default     = "test-data-bucket-971422682604-all"
}


variable "api_name" {
  description = "Name of the api gateway rest api"
  default     = "testDataAPI2"
}