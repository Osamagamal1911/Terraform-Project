variable "rds_security_group_ids" {
  description = "List of security group IDs for the RDS instance"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the RDS subnet group"
  type        = list(string)
}
