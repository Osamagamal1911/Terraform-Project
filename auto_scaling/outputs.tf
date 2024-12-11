output "asg1_id" {
  description = "The ID of the first auto-scaling group."
  value       = aws_autoscaling_group.as_group1.id
}

output "asg2_id" {
  description = "The ID of the second auto-scaling group."
  value       = aws_autoscaling_group.as_group2.id
}
