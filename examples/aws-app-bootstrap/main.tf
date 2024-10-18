provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    encrypt = true
    key = "global/aws-app-bootstrap-example/terraform.tfstate"
  }
}

module "bootstrap_app" {
  source            = "../../modules/aws-app-bootstrap"
  github_repository = "rdeak/my-office"
  aws_account_id    = "462090072481"
  aws_region        = "eu-west-1"
}

output "docker_repository_url" {
  value = module.bootstrap_app.docker_repository_url
}

output "docker_repository_name" {
  value = module.bootstrap_app.docker_repository_name
}

output "github_role_name" {
  value = module.bootstrap_app.github_role_name
}

output "github_role_arn" {
  value = module.bootstrap_app.github_role_arn
}

output "github_role_id" {
  value = module.bootstrap_app.github_role_id
}