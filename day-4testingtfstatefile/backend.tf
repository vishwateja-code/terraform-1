terraform {
  backend "s3" {
    bucket = "awsstatefile1"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}