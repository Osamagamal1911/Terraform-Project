variable "prefix" {
  description = "Prefix for resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "as_group1_id" {
  description = "The Name of the first auto_scaling."
  type        = string
}

variable "as_group2_id" {
  description = "The Name of the second auto_scaling"
  type        = string
}

variable "loadbalancer_sg_id" {
  description = "The security group ID for the load balancer"
  type        = list(string)
}