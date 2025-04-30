variable "env" {
  type    = list(string)
  default = [ "dev", "test", "prod"]
}

resource "aws_instance" "name" {
    ami = "ami-085ad6ae776d8f09c"
    instance_type = "t2.micro"
    count=length(var.env)

    tags = {
      Name = var.env[count.index]
    }
}