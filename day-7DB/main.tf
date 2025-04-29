# VPC
resource "aws_vpc" "dev" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "devvpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "ing1" {
  vpc_id = aws_vpc.dev.id
}

# Public Subnet 1
resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.dev.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-south-1a"
}

# Public Subnet 2
resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.dev.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1b"
}

# Route Table
resource "aws_route_table" "name" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ing1.id
  }
}

# Route Table Associations
resource "aws_route_table_association" "name" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.name.id
}

resource "aws_route_table_association" "name1" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.name.id
}

# DB Subnet Group
resource "aws_db_subnet_group" "db-sub" {
  subnet_ids = [aws_subnet.public1.id, aws_subnet.public2.id]
  tags = {
    Name = "My DB subnet group"
  }
}

# Primary RDS Instance
resource "aws_db_instance" "name" {
  engine                 = "mysql"
  engine_version         = "8.0"
  identifier             = "firststtformdb"
  username               = "admin"
  password               = "Shiva123"
  instance_class         = "db.t3.micro"
  allocated_storage      = 10
  db_subnet_group_name   = aws_db_subnet_group.db-sub.name
  parameter_group_name   = "default.mysql8.0"
  backup_retention_period = 7
  backup_window          = "02:00-03:00"
  monitoring_interval    = 60
  monitoring_role_arn    = aws_iam_role.rds_monitoring.arn
  maintenance_window     = "sun:04:00-sun:05:00"
  deletion_protection    = false         # ✅ Crucial for destroy
  skip_final_snapshot    = true

  tags = {
    Name = "Primary RDS"
  }
}

# IAM Role for Monitoring
resource "aws_iam_role" "rds_monitoring" {
  name = "rds-monitoring-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "monitoring.rds.amazonaws.com"
      }
    }]
  })
}

# IAM Policy Attachment
resource "aws_iam_role_policy_attachment" "rds_monitoring_attach" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# RDS Read Replica
resource "aws_db_instance" "read_replica" {
  identifier              = "book-rds-replica"
  replicate_source_db     = aws_db_instance.name.arn  # ✅ ARN
  instance_class          = "db.t3.micro"
  db_subnet_group_name    = aws_db_subnet_group.db-sub.name
  publicly_accessible     = true
  skip_final_snapshot     = true

  depends_on = [aws_db_instance.name]

  tags = {
    Name = "RDS Read Replica"
  }
}
