# Create security group for instance
resource "aws_security_group" "ec2_sg" {
  name        = "tf-ec2-sg"
  description = "SG allowing traffic to EC2"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "tf-ec2-sg"
  }
}

# Create EC2 instances SG ingress rule
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  description       = "Allow SSH from my IP"
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "79.205.73.90/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Create EC2 instances SG egress rule
resource "aws_vpc_security_group_egress_rule" "allowAllOutbound" {
  description       = "Allow all outbound traffic"
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Create security group for RDS
resource "aws_security_group" "rds_sg" {
  description = "Allow connection from EC2 SG"
  name        = "rds-sg-tf"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "rds-sg-tf"
  }
}

# Create RDS SG ingress rule
resource "aws_vpc_security_group_ingress_rule" "allow_ec2" {
  security_group_id = aws_security_group.rds_sg.id
  description       = "MariaDB from EC2"
  ip_protocol       = "tcp"
  from_port         = 3306
  to_port           = 3306
  referenced_security_group_id = aws_security_group.ec2_sg.id
}

# Create RDS SG egress rule
resource "aws_vpc_security_group_egress_rule" "rds_all" {
  security_group_id = aws_security_group.rds_sg.id
  description       = "Allow all outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}