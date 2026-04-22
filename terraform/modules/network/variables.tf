variable "vpc_name" { type = string }
variable "subnet_name" { type = string }
variable "subnet_cidr" { type = string }
variable "region" { type = string }
variable "project_id" { type = string }
variable "services_range_cidr" { type = string }
variable "pods_range_cidr" {
  type = string
}
