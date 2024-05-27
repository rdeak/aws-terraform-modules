variable "database_name" {
  description = " The name of the master database."
  type        = string
}

variable "database_user" {
  description = "The master user name for your new database."
  type        = string
}

variable "database_pass" {
  description = "The master password for your new database."
  type        = string
  sensitive   = true
}
