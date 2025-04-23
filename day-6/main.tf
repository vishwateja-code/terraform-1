# VPC
resource "aws_vpc" "dev" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "devvpc"
  }
}

# Internet Gateway attached to VPC
resource "aws_internet_gateway" "name" {
  vpc_id = aws_vpc.dev.id
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.dev.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-south-1a"
}

# Route Table
resource "aws_route_table" "name" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block = "0.0.0.0/0" # ✅ Fixed typo here: removed extra dot
    gateway_id = aws_internet_gateway.name.id
  }
}

# Route Table Association
resource "aws_route_table_association" "name" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.name.id
}

# Security Group
resource "aws_security_group" "allow_tls" {
  name   = "allow_tls"
  vpc_id = aws_vpc.dev.id
  tags = {
    Name = "dev-sg"
  }

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ✅ Fixed: removed extra dot in CIDR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "name" {
  ami                         = "ami-002f6e91abff6eb96"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_tls.id]

  tags = {
    Name = "dev-instance"
  }
}
