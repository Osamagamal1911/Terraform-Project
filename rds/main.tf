# RDS Subnet Group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = var.private_subnet_ids # List of private subnet IDs passed as a variable

  tags = {
    Name = "RDS Subnet Group"
  }
}

# RDS SQL Server Instance
resource "aws_db_instance" "rds_sql_server" {
  db_name                 = null
  allocated_storage       = 100
  engine                  = "sqlserver-se" # Choose SQL Server edition (e.g., sqlserver-ex, sqlserver-web)
  engine_version          = "15.00.4236.7.v1" # Specify a valid SQL Server version
  instance_class          = "db.m5.large" # Instance type
  multi_az                = true
  username                = "master"
  password                = "12345678"
  backup_retention_period = 7
  storage_type            = "gp3" # General Purpose SSD
  license_model           = "license-included" 

  vpc_security_group_ids = var.rds_security_group_ids # Security group IDs passed as a variable
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name

# Skip final snapshot when deleting the instance
  skip_final_snapshot     = true

  # Allows deletion without Terraform raising an error
  lifecycle {
    prevent_destroy = false
  }


  tags = {
    Name = "RDS SQL Server Instance"
  }
}
