output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "public_subnet_id" {
  value = aws_subnet.public_sub1[*].id
}
output "security_group_id" {
  value = aws_security_group.webSg.id
}
output "aws_key_pair" {
  value = aws_key_pair.key_name.key_name
}
output "aws_vpc_name" {
  value = aws_vpc.vpc.tags
}
output "elastic_IP" {
  value = aws_eip.nat_eip.public_ip
}