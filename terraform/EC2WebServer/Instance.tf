resource "aws_instance" "web" {
  ami                    = data.aws_ami.amiID.id
  instance_type          = "t3.micro"
  key_name               = "test-key"
  vpc_security_group_ids = [aws_security_group.tf-test-sg.id]
  availability_zone      = "eu-central-1a"

  tags = {
    Name    = "test-webpage"
    Project = "test"
  }

  provisioner "file" {
    source      = "web.sh"
    destination = "/tmp/web.sh"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("testkey")
    host        = self.public_ip
  }

  provisioner "remote-exec" {

    inline = [
      "chmod +x /tmp/web.sh",
      "sudo /tmp/web.sh"
    ]
  }
}

resource "aws_ec2_instance_state" "web-state" {
  instance_id = aws_instance.web.id
  state       = "running"
}