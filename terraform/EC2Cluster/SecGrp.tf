# Create security group for instances
resource "aws_security_group" "ec2-test-sg" {
  name        = "ec2-test-sg"
  description = "security group for TF test tasks"
  vpc_id      = aws_vpc.devops_vpc.id

  tags = {
    Name = "ec2-test-sg"
  }
}

# Create EC2 instances SG ingress rules
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  description                  = "Allow HTTP from load balancer"
  security_group_id            = aws_security_group.ec2-test-sg.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
  referenced_security_group_id = aws_security_group.lb_sg.id
}

resource "aws_vpc_security_group_ingress_rule" "sshfromyIP" {
  description       = "Allow SSH from my IP"
  security_group_id = aws_security_group.ec2-test-sg.id
  cidr_ipv4         = "79.205.73.90/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Create EC2 instances SG egress rule
resource "aws_vpc_security_group_egress_rule" "allowAllOutbound" {
  description       = "Allow all outbound traffic"
  security_group_id = aws_security_group.ec2-test-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Create security group for load balancer
resource "aws_security_group" "lb_sg" {
  description = "Security group for load balancer"
  name        = "nginx-lb-sg"
  vpc_id      = aws_vpc.devops_vpc.id

  tags = {
    Name = "nginx-lb-sg"
  }
}

# Create load balancer SG ingress rule
resource "aws_vpc_security_group_ingress_rule" "lb_http" {
  security_group_id = aws_security_group.lb_sg.id
  description       = "Allow HTTP from anywhere"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

# Create load balancer SG egress rule
resource "aws_vpc_security_group_egress_rule" "lb_all" {
  security_group_id = aws_security_group.lb_sg.id
  description       = "Allow all outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}