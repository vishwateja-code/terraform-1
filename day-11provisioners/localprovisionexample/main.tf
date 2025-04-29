provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "name" {
  ami = "ami-0e449927258d45bc4"
  instance_type = "t2.micro"
  tags = {
    Name = "null resource"
  }
provisioner "local-exec" {
  command = "echo Instance public IP is ${self.private_ip} > instance_info.txt"
}
}
