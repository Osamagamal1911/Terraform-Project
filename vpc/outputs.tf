output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC."
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets."
  value       = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id,
  ]
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets."
  value       = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id,
  ]
}

output "nat_gateway_id" {
  description = "The ID of the NAT gateway."
  value       = aws_nat_gateway.nat.id
}

output "internet_gateway_id" {
  description = "The ID of the Internet gateway."
  value       = aws_internet_gateway.igw.id
}
