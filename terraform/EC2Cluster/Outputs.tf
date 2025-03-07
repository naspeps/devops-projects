output "lb_dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.nginx.dns_name
}

output "instance_ids" {
  description = "IDs of the created EC2 instances"
  value       = aws_instance.nginx[*].id
}

output "instance_public_ips" {
  description = "Public IPs of the created EC2 instances"
  value       = aws_instance.nginx[*].public_ip
}