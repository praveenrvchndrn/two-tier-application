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
    description = "User_Name" 
}
variable "aws_vpc" {
}
#variable "aws_security_group" { 
#}
#variable "aws_subnet_public" {
#}
#variable "aws_subnet_private_a" {
#}
#variable "aws_subnet_private_b" {
#}