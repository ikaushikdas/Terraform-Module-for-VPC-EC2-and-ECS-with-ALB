# VPC Module Outputs
output "vpc_id" {
  value = module.vpc_module.vpc_id
}
output "aws_vpc_name" {
  value = module.vpc_module.aws_vpc_name
}
output "public_subnet_id" {
  value = module.vpc_module.public_subnet_id
}
output "security_group_id" {
  value = module.vpc_module.security_group_id
}
# output "aws_key_pair" {
#   value = module.vpc_module.aws_key_pair
# }
output "elastic_IP" {
  value = module.vpc_module.elastic_IP
}
# ----

# ALB Module Outputs
output "load_balancer_endpoint" {
  value = module.alb_module.load_balancer_endpoint
}
#----