provider "aws" {
  region = "us-west-1"
}

terraform {
  backend "s3" {
    encrypt = true
    key = "global/aws-app-bootstrap-example/terraform.tfstate"
  }
}

module "bootstrap_app" {
  source            = "../../modules/aws-app-bootstrap"
  github_repository = "user/repo"
  aws_account_id    = "1234567890"
  aws_region        = "us-east-1"
}

output "docker_repository_url" {
  value = module.bootstrap_app.docker_repository_url
}

output "docker_repository_name" {
  value = module.bootstrap_app.docker_repository_name
}

output "docker_repository_arn" {
  value = module.bootstrap_app.docker_repository_arn
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