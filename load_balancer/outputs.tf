output "load_balancer_id" {
  description = "The ID of the ALB"
  value       = aws_lb.app_lb.id
}

output "load_balancer_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.app_lb.dns_name
}
