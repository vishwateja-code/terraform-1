variable "rds-password" {
    description = "rds password"
    type = string
    default = "Shiva123"
  
}
variable "rds-username" {
    description = "rds username"
    type = string
    default = "admin"
  
}
variable "ami" {
    description = "ami"
    type = string
    default = "ami-04b70fa74e45c3917"
  
}
variable "instance-type" {
    description = "instance-type"
    type = string
    default = "t2.micro"
  
}
variable "us" {
    description = "keyname"
    type = string
    default = "us"
  
}
variable "backupr-retention" {
    type = number
    default = "7"
  
}
