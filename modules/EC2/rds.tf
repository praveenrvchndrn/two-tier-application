resource "aws_db_subnet_group" "main" {
  name       = "two-tier-db-subnet-group"
  subnet_ids = [var.aws_subnet_private_a, var.aws_subnet_private_b]
  tags = { Name = "two-tier-db-subnet-group" }
}

resource "aws_db_instance" "mysql" {
  identifier        = "two-tier-mysql"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = var.db_name
  username = var.db_user
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.security_group]

  skip_final_snapshot     = true   # set false for prod
  publicly_accessible     = false
  backup_retention_period = 0

  tags = { Name = "two-tier-mysql" }
}