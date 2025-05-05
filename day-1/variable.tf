variable "ami_id" {
    description = "inserting amiid into main"
    type = string
    default = "ami-0f88e80871fd81e91"
  
}

variable "instance_type" {
    type = string
    default = "t2.nano"
  
}