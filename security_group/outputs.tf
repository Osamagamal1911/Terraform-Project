# Outputs
output "public_sg_id" {
  description = "ID of the public security group"
  value       = aws_security_group.public_sg.id
}

output "loadbalancer_sg_id" {
  value = [aws_security_group.loadbalancer_sg.id]  # Wrap it in brackets to make it a list
}


output "private_sg_id" {
  description = "ID of the private security group"
  value       = aws_security_group.private_sg.id
}

output "rds_sg_id" {
  description = "Security Group ID for RDS allowing SQL traffic from private instances"
  value       = [aws_security_group.rds_sg.id]
}
