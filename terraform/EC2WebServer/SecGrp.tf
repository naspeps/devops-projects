resource "aws_security_group" "tf-test-sg" {
  name        = "tf-test-sg"
  description = "security group for TF test tasks"
  tags = {
    Name = "tf-test-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "sshfromyIP" {
  security_group_id = aws_security_group.tf-test-sg.id
  cidr_ipv4         = "79.205.73.90/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.tf-test-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allowAllOutbound_ipv4" {
  security_group_id = aws_security_group.tf-test-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allowAllOutbound_ipv6" {
  security_group_id = aws_security_group.tf-test-sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}