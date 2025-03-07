# Create EC2 instances
resource "aws_instance" "nginx" {
  count                  = var.instance_count
  ami                    = data.aws_ami.amiID.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2-test-sg.id]
  subnet_id              = aws_subnet.primary.id
  user_data = templatefile("${path.module}/nginx.sh", {
    instance_num = count.index + 1
  })

  tags = {
    Name    = "nginx-test-webpage"
    Project = "nginx-test"
  }
}

# Create target group for ALB
resource "aws_lb_target_group" "nginx" {
  name     = "nginx-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.devops_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Attach instances to target group
resource "aws_lb_target_group_attachment" "nginx" {
  count            = var.instance_count
  target_group_arn = aws_lb_target_group.nginx.arn
  target_id        = aws_instance.nginx[count.index].id
  port             = 80

  depends_on = [aws_instance.nginx]  # Ensures EC2 instances are created first
}

# Create ALB
resource "aws_lb" "nginx" {
  name                       = "nginx-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.lb_sg.id]
  subnets                    = [aws_subnet.primary.id, aws_subnet.secondary.id]
  enable_deletion_protection = false

  tags = {
    Name = "nginx-lb"
  }
}

# Create listener for ALB
resource "aws_lb_listener" "nginx" {
  load_balancer_arn = aws_lb.nginx.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }
}

resource "aws_ec2_instance_state" "web-state" {
  count       = var.instance_count
  instance_id = aws_instance.nginx[count.index].id
  state       = "running"
}