variable "project_name" {
  type = string
  description = "Project name"
}

variable "vpc_id" {
  type = string
  description = "VPC id where "
}

variable "name" {
  type = string
  description = "Database name"
}

variable "username" {
  type = string
  description = "Database username"
}

variable "password" {
  type = string
  description = "Database password"
  sensitive = true
}

variable "min_capacity" {
  type = number
  description = "Min Scaling Capacity"
  default = 0.5
}

variable "max_capacity" {
  type = number
  description = "Max Scaling Capacity"
  default = 1
}