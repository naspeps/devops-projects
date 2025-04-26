output "s3_bucket_name" {
  value = aws_s3_bucket.data_bucket.bucket
}

output "api_gateway_invoke_url" {
  description = "Invoke URL for API Gateway"
  value       = aws_api_gateway_deployment.deployment.invoke_url
}
