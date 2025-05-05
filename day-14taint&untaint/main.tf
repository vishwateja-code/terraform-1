resource "aws_instance" "name" {
  ami="ami-0f88e80871fd81e91"
  instance_type = "t2.micro"
}

resource "aws_s3_bucket" "name" {
    bucket = "rftgyuiosdfghbuyg"
  
}