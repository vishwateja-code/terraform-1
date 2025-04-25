provider "aws" {
  region = "us-east-1"
}

module "web_server" {
  source        = "./modules/ec2"
  ami           = "ami-0e449927258d45bc4" 
  instance_type = "t3.micro"
  name          = "my-web-server"
}
module "simple_s3" {
  source      = "./modules/s3"
  bucket_name = "my-simple-s3-bucket-123456789011"
}
module "my_rds" {
  source            = "./modules/rds"
  identifier        = "my-dev-db"
  engine            = "mysql"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  username          = "admin"
  password          = "Shiva123!"
  db_name           = "myappdb"
}