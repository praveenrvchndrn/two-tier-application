variable "ami_id" {
  description = "AMI Value"
}
variable "instance_type" {
    description = "Instance type" 
}
variable "region" {
    default = "us-east-1"
    description = "Region"
}
variable "db_name" {
    default = "appdb"
}
variable "db_password" {
    sensitive = true
}
variable "db_user" {
    type = string
    description = "User_Name" 
}
variable "vpc_id" {
    type = string
    description = "VPC ID from vpc module"
}
variable "security_group" { 
    type = string
}
variable "aws_subnet_public_1" {
    type = string
}
variable "aws_subnet_public_2" {
    type = string
}
variable "aws_subnet_private_a" {
    type = string
}
variable "aws_subnet_private_b" {
    type = string
}