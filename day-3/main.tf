resource "aws_instance" "dev" {
  ami = var.ami
  instance_type = var.type
 
}
#}
#resource "aws_s3_bucket" "name" {
#bucket = var.bucket
  
#}
