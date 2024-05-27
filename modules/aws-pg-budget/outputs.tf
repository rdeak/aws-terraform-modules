output "database_host" {
  value = aws_lightsail_database.main.master_endpoint_address
  description = "The master endpoint fqdn for the database."
}

output "database_port" {
  value = aws_lightsail_database.main.master_endpoint_port
  description = "The master endpoint network port for the database."
}

output "database_user" {
  value = aws_lightsail_database.main.master_username
  description = "The master user for the database."
}

output "database_pass" {
  value = aws_lightsail_database.main.master_password
  description = "The master password for the database."
}

output "database_base" {
  value = aws_lightsail_database.main.master_database_name
  description = "The master database name from the database."
}
