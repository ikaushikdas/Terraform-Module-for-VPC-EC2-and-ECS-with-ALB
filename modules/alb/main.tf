provider "aws" {
  region = var.region
}

# Create ALB
resource "aws_lb" "my_lb" {
  name               = "ui-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_id_value # Replace with your subnet IDs
  security_groups    = [var.sg_value]  # Replace with your security group IDs
}
# Create ALB listener
resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}
# Create ALB target group
resource "aws_lb_target_group" "my_target_group" {
  name        = "ui-task"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id  # Replace with your VPC ID
  target_type = "ip"
}