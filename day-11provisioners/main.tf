provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "task_key" {
  key_name   = "task"
  public_key = file("task.pub")
}


resource "aws_instance" "ec2" {
  ami           = "ami-084568db4383264d4"  # make sure this is a valid Ubuntu AMI
  instance_type = "t2.micro"
  key_name      = aws_key_pair.task_key.key_name

 connection {
  type        = "ssh"
  user        = "ubuntu"  # only if the AMI is Ubuntu
  private_key = file("C:/Users/Hello/.ssh/id_rsa")
  host        = self.public_ip
}


  provisioner "local-exec" {
    command = "touch file500"  # runs locally, not on EC2
  }

  provisioner "file" {
    source      = "file10"  # file must exist in same folder as .tf file
    destination = "/home/ubuntu/file10"
  }

  provisioner "remote-exec" {
    inline = [
      "touch file200",
      "echo hello from aws >> file200"
    ]
  }

  tags = {
    Name = "Provisioned-EC2"
  }
}

