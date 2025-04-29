provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "task_key" {
  key_name   = "task"
  public_key = file("task.pub")
}

resource "aws_instance" "ec2" {
  ami           = "ami-084568db4383264d4"  # Ubuntu 20.04 in us-east-1
  instance_type = "t2.micro"
  key_name      = aws_key_pair.task_key.key_name

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y nginx",
      "sudo systemctl start nginx"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("C:/Users/Hello/.ssh/id_rsa")
    host        = self.public_ip
  }

  tags = {
    Name = "nginx-instance"
  }
}
