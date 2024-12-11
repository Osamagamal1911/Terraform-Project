# Data source to get the latest Windows Server AMI
data "aws_ami" "windows" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }
}

# Randomly select one of the public subnets
resource "random_shuffle" "public_subnet" {
  input        = var.public_subnet_ids
  result_count = 1
}

# Bastion Host EC2 Instance
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.windows.id
  instance_type               = var.instance_type
  subnet_id                   = random_shuffle.public_subnet.result[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.public_security_group_id]
  key_name                    = var.key
  tags = {
    Name = "${var.prefix}-bastion-host"
  }

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = "gp3"
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [user_data]
  }
}

# Use an external script to stop the instance after creation
resource "null_resource" "stop_bastion" {
  provisioner "local-exec" {
    command = "aws ec2 stop-instances --instance-ids ${aws_instance.bastion.id} --region ${var.region}"
  }

  depends_on = [aws_instance.bastion]
}
