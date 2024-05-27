locals {
  relational_database_name = replace(var.database_name, "/[^a-zA-Z0-9]/", "-")
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_lightsail_database" "main" {
  relational_database_name = local.relational_database_name
  availability_zone        = data.aws_availability_zones.available.names[0]
  master_database_name     = var.database_name
  master_username          = var.database_user
  master_password          = var.database_pass
  blueprint_id             = "postgres_16"
  bundle_id                = "micro_2_0"
  publicly_accessible      = true
  apply_immediately        = true

  tags = {
    Name = var.database_name
  }
}
