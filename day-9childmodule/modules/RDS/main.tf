resource "aws_db_instance" "this" {
  identifier              = var.identifier
  engine                  = var.engine
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  username                = var.username
  password                = var.password
  db_name                 = var.db_name
  skip_final_snapshot     = true
  publicly_accessible     = true
}
