resource "aws_instance" "my_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker
              docker login -u ${var.dockerhub_username} -p ${var.dockerhub_token}
              docker pull ${var.dockerhub_username}/flask-app:latest
              docker run -d -p 80:5000 ${var.dockerhub_username}/flask-app:latest
              EOF

    instance_market_options {
    market_type = "spot"

    spot_options {
      instance_interruption_behavior = "stop"     # stop instead of terminate
      max_price                      = var.spot_max_price
      spot_instance_type             = "persistent"  # persistent instead of one-time
    }
  }


  tags = {
    Name = var.instance_name
  }

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }
}
