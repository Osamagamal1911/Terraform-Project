variable "private_subnet_ids" {
  description = "List of private subnet IDs for the auto-scaling group."
  type        = list(string)
}

variable "private_sg_id" {
  description = "The ID of the private security group."
  type        = string
}

variable "prefix" {
  description = "Prefix for naming resources."
  type        = string
}

variable "key" {
  description = "key pair"
  type        = string
}