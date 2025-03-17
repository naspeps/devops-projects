output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = module.ec2_instance.public_ip
}

output "rds_endpoint"{
    description = "db connection endpoint"
    value       = module.rds.db_instance_endpoint

}