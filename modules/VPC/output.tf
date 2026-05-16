output "vpc_id" {
    value = aws_vpc.main.id
}
output "security_groups" {
  value = aws_security_group.alb.id
}
output "public_1" {
  value = aws_subnet.public_1.id
}
output "public_2" {
  value = aws_subnet.public_2.id
}
output "private_a" {
  value = aws_subnet.private_a.id
}
output "private_b" {
  value = aws_subnet.private_b.id
}
