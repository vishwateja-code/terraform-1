resource "aws_key_pair" "name1" {
  key_name   = "publiccccc"
 public_key = file("C:/Users/Hello/.ssh/id_rsa.pub")

}
