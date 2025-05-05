locals {
  region = "us-east-1"
  instance_type="t2.micro"
}
resource "aws_instance" "name" {
  ami="ami-0f88e80871fd81e91"
  instance_type = local.instance_type
  
  tags = {
    name= "App-${local.region}"
  }
}