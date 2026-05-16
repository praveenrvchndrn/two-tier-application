module "aws_s3_bucket" {
    source = "./s3" 
    aws_s3 = "two-tier-app-1405"
    aws_s3_region = "us-east-1"
}

module "vpc" {
    source = "./VPC" 
}

module "ec2" {
    source = "./EC2"
    instance_type = "m7i-flex.large"
    ami_id = "ami-091138d0f0d41ff90"
    db_user = "appuser
    db_password = var.db_password

}