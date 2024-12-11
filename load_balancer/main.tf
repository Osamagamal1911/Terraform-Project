resource "aws_lb" "app_lb" {
  name               = "${var.prefix}-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.loadbalancer_sg_id
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "${var.prefix}-app-lb"
  }
}

resource "aws_lb_target_group" "asg1_target_group" {
  name     = "${var.prefix}-asg1-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold  = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "asg2_target_group" {
  name     = "${var.prefix}-asg2-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold  = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.asg1_target_group.arn
  }
}

resource "aws_lb_listener_rule" "asg2_listener_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["/static/*"]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.asg2_target_group.arn
  }
}

# Attach Auto Scaling Group 1 to the ALB Target Group
resource "aws_autoscaling_attachment" "asg1_attachment" {
  autoscaling_group_name = var.as_group1_id
  lb_target_group_arn    = aws_lb_target_group.asg1_target_group.arn
}

# Attach Auto Scaling Group 2 to the ALB Target Group
resource "aws_autoscaling_attachment" "asg2_attachment" {
  autoscaling_group_name = var.as_group2_id
  lb_target_group_arn    = aws_lb_target_group.asg2_target_group.arn
}

output "alb_arn" {
  value = aws_lb.app_lb.arn
}

output "asg1_target_group_arn" {
  value = aws_lb_target_group.asg1_target_group.arn
}

output "asg2_target_group_arn" {
  value = aws_lb_target_group.asg2_target_group.arn
}
