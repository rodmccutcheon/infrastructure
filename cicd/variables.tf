variable "access_key" {}

variable "secret_key" {}

variable "region" {
  default = "ap-southeast-2"
}

variable "subnet_ids" {
  type        = "list"
  description = "Subnet ids"
}

variable "vpc_id" {
  description = "The VPC id"
}

# variable "allowed_security_group_id" {
#   description = "The allowed security group id to connect on RDS"
# }

variable "allocated_storage" {
  description = "The storage size in GB"
  default     = "20"
}

variable "instance_class" {
  description = "The instance type"
}

variable "instance_user" {
  description = "The instance username"
  default     = "ec2-user"
}

variable "multi_az" {
  description = "Muti-az allowed?"
  default     = false
}

variable "database_name" {
  description = "The database name"
}

variable "database_username" {
  description = "The username of the database"
}

variable "database_password" {
  description = "The password of the database"
}