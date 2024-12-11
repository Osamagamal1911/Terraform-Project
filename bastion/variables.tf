variable "public_subnet_ids" {
  description = "List of public Subnet IDs for the bastion host"
  type        = list(string)
}

variable "public_security_group_id" {
  description = "Security Group ID for the bastion host"
  type        = string
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the bastion host"
  type        = string
  default     = "t3.micro"
}

variable "volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 30
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "key" {
  description = "key pair"
  type        = string
}