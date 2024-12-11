# Data source to get the latest Windows Server AMI
data "aws_ami" "windows" {
  most_recent = true

  owners = ["amazon"] # AMIs owned by Amazon

  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"] # Adjust as needed
  }
}

# Create Launch Template with gp3 150GB EBS volume
resource "aws_launch_template" "windows_lt" {
  name_prefix   = "${var.prefix}-windows-lt"
  image_id      = data.aws_ami.windows.id
  instance_type = "t3.medium" # Change as needed
  key_name      = var.key

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.private_sg_id]
  }

  block_device_mappings {
    device_name = "/dev/sda1" # Root device
    ebs {
      volume_size           = 150   # 150 GB
      volume_type           = "gp3" # General Purpose SSD (gp3)
      delete_on_termination = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create Auto Scaling Group 1 with a specific name
resource "aws_autoscaling_group" "as_group1" {
  name                = "${var.prefix}-asg1" # ASG name
  launch_template {
    id      = aws_launch_template.windows_lt.id
    version = "$Latest"
  }

  min_size            = 1
  max_size            = 2
  desired_capacity    = 2
  vpc_zone_identifier = var.private_subnet_ids

  tag {
      key                 = "Name"
      value               = "${var.prefix}-asg1-instance"
      propagate_at_launch = true
  }

  depends_on = [aws_launch_template.windows_lt] # Add dependency on the Launch Template
}

# Create Auto Scaling Group 2 with a specific name
resource "aws_autoscaling_group" "as_group2" {
  name                = "${var.prefix}-asg2" # ASG name
  launch_template {
    id      = aws_launch_template.windows_lt.id
    version = "$Latest"
  }

  min_size            = 2
  max_size            = 3
  desired_capacity    = 2
  vpc_zone_identifier = var.private_subnet_ids

  tag {
      key                 = "Name"
      value               = "${var.prefix}-asg2-instance"
      propagate_at_launch = true
  }

  depends_on = [aws_launch_template.windows_lt] # Add dependency on the Launch Template
}

# CloudWatch Alarm for CPU High for ASG 1
resource "aws_cloudwatch_metric_alarm" "cpu_high_asg1" {
  alarm_name          = "${var.prefix}-cpu-high-asg1"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"  # 5 minutes
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This alarm triggers when CPU utilization exceeds 80%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.as_group1.name
  }

  alarm_actions = [
    aws_autoscaling_policy.scale_up_asg1.arn,
  ]
}

# CloudWatch Alarm for CPU Low for ASG 1
resource "aws_cloudwatch_metric_alarm" "cpu_low_asg1" {
  alarm_name          = "${var.prefix}-cpu-low-asg1"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"  # 5 minutes
  statistic           = "Average"
  threshold           = 20
  alarm_description   = "This alarm triggers when CPU utilization drops below 20%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.as_group1.name
  }

  alarm_actions = [
    aws_autoscaling_policy.scale_down_asg1.arn,
  ]
}

# CloudWatch Alarm for Memory High for ASG 1
resource "aws_cloudwatch_metric_alarm" "memory_high_asg1" {
  alarm_name          = "${var.prefix}-memory-high-asg1"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/EC2"
  period              = "300"  # 5 minutes
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This alarm triggers when Memory utilization exceeds 80%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.as_group1.name
  }

  alarm_actions = [
    aws_autoscaling_policy.scale_up_asg1.arn,
  ]
}

# CloudWatch Alarm for Memory Low for ASG 1
resource "aws_cloudwatch_metric_alarm" "memory_low_asg1" {
  alarm_name          = "${var.prefix}-memory-low-asg1"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/EC2"
  period              = "300"  # 5 minutes
  statistic           = "Average"
  threshold           = 20
  alarm_description   = "This alarm triggers when Memory utilization drops below 20%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.as_group1.name
  }

  alarm_actions = [
    aws_autoscaling_policy.scale_down_asg1.arn,
  ]
}

# Scaling policy for ASG 1 - Scale Up
resource "aws_autoscaling_policy" "scale_up_asg1" {
  name                   = "${var.prefix}-scale-up-asg1"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.as_group1.name
}

# Scaling policy for ASG 1 - Scale Down
resource "aws_autoscaling_policy" "scale_down_asg1" {
  name                   = "${var.prefix}-scale-down-asg1"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.as_group1.name
}

# CloudWatch Alarm for CPU High for ASG 2
resource "aws_cloudwatch_metric_alarm" "cpu_high_asg2" {
  alarm_name          = "${var.prefix}-cpu-high-asg2"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"  # 5 minutes
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This alarm triggers when CPU utilization exceeds 80%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.as_group2.name
  }

  alarm_actions = [
    aws_autoscaling_policy.scale_up_asg2.arn,
  ]
}

# CloudWatch Alarm for CPU Low for ASG 2
resource "aws_cloudwatch_metric_alarm" "cpu_low_asg2" {
  alarm_name          = "${var.prefix}-cpu-low-asg2"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"  # 5 minutes
  statistic           = "Average"
  threshold           = 20
  alarm_description   = "This alarm triggers when CPU utilization drops below 20%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.as_group2.name
  }

  alarm_actions = [
    aws_autoscaling_policy.scale_down_asg2.arn,
  ]
}

# CloudWatch Alarm for Memory High for ASG 2
resource "aws_cloudwatch_metric_alarm" "memory_high_asg2" {
  alarm_name          = "${var.prefix}-memory-high-asg2"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/EC2"
  period              = "300"  # 5 minutes
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This alarm triggers when Memory utilization exceeds 80%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.as_group2.name
  }

  alarm_actions = [
    aws_autoscaling_policy.scale_up_asg2.arn,
  ]
}

# CloudWatch Alarm for Memory Low for ASG 2
resource "aws_cloudwatch_metric_alarm" "memory_low_asg2" {
  alarm_name          = "${var.prefix}-memory-low-asg2"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/EC2"
  period              = "300"  # 5 minutes
  statistic           = "Average"
  threshold           = 20
  alarm_description   = "This alarm triggers when Memory utilization drops below 20%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.as_group2.name
  }

  alarm_actions = [
    aws_autoscaling_policy.scale_down_asg2.arn,
  ]
}

# Scaling policy for ASG 2 - Scale Up
resource "aws_autoscaling_policy" "scale_up_asg2" {
  name                   = "${var.prefix}-scale-up-asg2"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.as_group2.name
}

# Scaling policy for ASG 2 - Scale Down
resource "aws_autoscaling_policy" "scale_down_asg2" {
  name                   = "${var.prefix}-scale-down-asg2"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.as_group2.name
}
