locals {
  aws_region = "us-east-1"
}

provider "aws" {
  region = local.aws_region
}

terraform {
  backend "s3" {
    key = "global/aws-pg-budget/terraform.tfstate"
  }
}

module "app" {
  source        = "../../modules/aws-pg-budget"
  database_name = "my_db"
  database_user = "user"
  database_pass = "pass"
}

output "host" {
  value = module.app.database_host
}

output "port" {
  value = module.app.database_port
}

output "base" {
  value = module.app.database_base
}

output "user" {
  value = module.app.database_user
}

output "pass" {
  value     = module.app.database_pass
  sensitive = true
}