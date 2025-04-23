# vpc
resource "aws_vpc" "dev" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true        # ✅ Required
  enable_dns_hostnames = true        # ✅ Required
  tags = {
    Name = "devvpc"
  }
}

# igw
resource "aws_internet_gateway" "ing1" {
  vpc_id = aws_vpc.dev.id
}
# public subnet 1
resource "aws_subnet" "public1" {
  vpc_id = aws_vpc.dev.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-south-1a"
}
#public subnet 2
resource "aws_subnet" "public2" {
  vpc_id = aws_vpc.dev.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1b"
}
# rt
resource "aws_route_table" "name" {
  vpc_id = aws_vpc.dev.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ing1.id
  }
}
# subnet association
resource "aws_route_table_association" "name" {
  subnet_id = aws_subnet.public1.id
  route_table_id = aws_route_table.name.id
}
resource "aws_route_table_association" "name1" {
  subnet_id = aws_subnet.public2.id
  route_table_id = aws_route_table.name.id
}
# subnet group
resource "aws_db_subnet_group" "db-sub" {
  subnet_ids = [aws_subnet.public1.id , aws_subnet.public2.id]
  provider = aws.primary
  tags = {
    Name = "My DB subnet group"
  }
}
resource "aws_db_instance" "name" {
  engine               = "mysql"
  engine_version       = "8.0"
  identifier           = "firststtformdb"
  username             = "admin"
  password             = "Shiva123"
  instance_class       = "db.t3.micro"                     # fixed here
  allocated_storage    = 10
  db_subnet_group_name = aws_db_subnet_group.db-sub.name  # fixed here
  parameter_group_name = "default.mysql8.0"
  provider             = aws.primary

  backup_retention_period = 7
  backup_window           = "02:00-03:00"
  monitoring_interval     = 60
  monitoring_role_arn     = aws_iam_role.rds_monitoring.arn

  maintenance_window   = "sun:04:00-sun:05:00"
  deletion_protection  = true
  skip_final_snapshot  = true

  tags = {
    Name = "Primary RDS"
  }
}


# IAM Role for RDS Enhanced Monitoring
resource "aws_iam_role" "rds_monitoring" {
  name = "rds-monitoring-role"
  provider = aws.primary
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "monitoring.rds.amazonaws.com"
      }
    }]
  })
}

# IAM Policy Attachment for RDS Monitoring
resource "aws_iam_role_policy_attachment" "rds_monitoring_attach" {
  provider = aws.primary  
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_db_instance" "read_replica" {
  identifier              = "book-rds-replica"
  replicate_source_db     = aws_db_instance.name.arn  # ✅ use ARN here
  instance_class          = "db.t3.micro"
  db_subnet_group_name    = aws_db_subnet_group.db-sub.name
  publicly_accessible     = true
  skip_final_snapshot     = true

  depends_on = [aws_db_instance.name]

  tags = {
    Name = "RDS Read Replica"
  }
}

