variable "region" {
  description = "The AWS region to deploy resources."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for public subnet 1."
  type        = string
  default     = "10.0.2.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for public subnet 2."
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for private subnet 1."
  type        = string
  default     = "10.0.0.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for private subnet 2."
  type        = string
  default     = "10.0.1.0/24"
}
