output "aws_s3_bucket" {
    value = module.aws_s3_bucket
}

output "ec2_Ip" {
    value = module.ec2.ec2_public_ip
}

output "alb_dns" {
    value = module.ec2.alb_dns
}

output "rds_endpoint" {
  value = module.ec2.rds_endpoint
}