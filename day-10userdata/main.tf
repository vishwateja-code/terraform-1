resource "aws_instance" "dev" {
  ami           = "ami-0e449927258d45bc4"
  instance_type = "t2.micro"

  user_data = file("test.sh")

  tags = {
    Name = "dev"
  }
}
