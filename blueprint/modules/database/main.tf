
###########################################################
# RDS Database
###########################################################

# Create Subnet Group
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = var.tags
}

# Create RDS Instance
resource "aws_db_instance" "rds" {
  identifier              = "tf-task-database"
  instance_class          = var.instance_class
  allocated_storage       = var.storage_allocation
  storage_type            = var.storage_type
  engine                  = var.db_engine
  engine_version          = var.db_engine_version
  name                    = var.db_name
  port                    = var.db_port
  username                = var.db_user_name
  password                = var.db_password
  skip_final_snapshot     = true
  backup_retention_period = 0
  apply_immediately       = true
  multi_az                = true
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = var.security_group_ids
  tags                    = var.tags
}

