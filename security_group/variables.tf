variable "vpc_id" {
  description = "The ID of the VPC to associate the security groups with."
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block of the VPC."
  type        = string
}

variable "prefix" {
  description = "Prefix for the security group names."
  type        = string
}
