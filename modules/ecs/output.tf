output "load_balancer_endpoint" {
  value = aws_lb.my_lb.dns_name
}