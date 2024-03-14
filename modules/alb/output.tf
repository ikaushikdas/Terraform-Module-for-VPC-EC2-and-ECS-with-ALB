output "alb_arn" {
  value = aws_lb_target_group.my_target_group.arn
}
output "load_balancer_endpoint" {
  value = aws_lb.my_lb.dns_name
}