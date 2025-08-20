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
              mkfs -t ext4 /dev/xvdf || true
              mkdir -p /mnt/data
              mount /dev/xvdf /mnt/data
              echo "/dev/xvdf /mnt/data ext4 defaults,nofail 0 2" >> /etc/fstab
              docker login -u ${var.dockerhub_username} -p ${var.dockerhub_token}
              docker pull ${var.dockerhub_username}/flask-app:latest
              docker run -d -p 80:5000 ${var.dockerhub_username}/flask-app:latest
              EOF

  instance_market_options {
    market_type = "spot"

    spot_options {
      instance_interruption_behavior = "stop" # stop instead of terminate
      max_price                      = var.spot_max_price
      spot_instance_type             = "persistent" # persistent instead of one-time
    }
  }


  tags = {
    Name = var.instance_name
  }

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create the persistent EBS volume
resource "aws_ebs_volume" "my_data_volume" {
  availability_zone = var.availability_zone # Must match instance AZ
  size              = 20                    # in GB, adjust as needed
  type              = "gp3"                 # general-purpose SSD
  encrypted         = true

  tags = {
    Name = "${var.instance_name}-data"
  }
}

# Attach the EBS volume to your Spot instance
resource "aws_volume_attachment" "my_data_attachment" {
  device_name = "/dev/sdf" # Linux will map this to /dev/xvdf
  volume_id   = aws_ebs_volume.my_data_volume.id
  instance_id = aws_instance.my_ec2.id
}
