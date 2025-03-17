module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "app-server-tf-2"
  
  ami                    = "ami-0584590e5f0e97daa" # Debian 12
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  subnet_id              = module.vpc.public_subnets[0]
  associate_public_ip_address = true

  tags = {
    Terraform   = "true"
    Environment = "test"
  }
}