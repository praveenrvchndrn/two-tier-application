output "alb_dns" {
    value = aws_lb.app.dns_name
}

output "rds_endpoint" {
    value = aws_db_instance.mysql.address
}

output "ec2_public_ip" {
    value = aws_instance.app.public_ip
}