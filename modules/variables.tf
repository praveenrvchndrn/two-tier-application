variable "region" {
    default = "us-east-1"
    type = string
    description = "Region value" 
}

variable "db_password" {
    description = "Password for DB"
    type = string
    sensitive = true
  
}