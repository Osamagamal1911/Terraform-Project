# Outputs
output "rds_instance_id" {
  description = "ID of the RDS SQL Server instance"
  value       = aws_db_instance.rds_sql_server.id
}

output "rds_endpoint" {
  description = "Endpoint of the RDS SQL Server instance"
  value       = aws_db_instance.rds_sql_server.endpoint
}

output "rds_port" {
  description = "Port number for the RDS SQL Server instance"
  value       = aws_db_instance.rds_sql_server.port
}

output "rds_subnet_group_name" {
  description = "Name of the RDS subnet group"
  value       = aws_db_subnet_group.rds_subnet_group.name
}

output "rds_security_group_ids" {
  description = "Security group IDs associated with the RDS instance"
  value       = var.rds_security_group_ids
}
