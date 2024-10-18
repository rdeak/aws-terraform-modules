provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    encrypt = true
    key = "global/aws-lambda-api-example/terraform.tfstate"
  }
}

module "lambda_api" {
  source            = "../../modules/aws-lambda-api"
  aws_region        = "us-east-1"
  docker_repository_arn = "arn:aws:ecr:us-west-1:1234567890:repository/user-repo"
  docker_repository_url = "1234567890.dkr.ecr.us-west-1.amazonaws.com/user-repo"
  lambda_function_name = "test-fn"
}

output "lambda_api_endpoint" {
  value = module.lambda_api.api_endpoint
}
output "lambda_api_lambda_exec_role_arn" {
  value = module.lambda_api.lambda_exec_role_arn
}
output "lambda_api_lambda_exec_role_id" {
  value = module.lambda_api.lambda_exec_role_id
}
output "lambda_api_lambda_exec_role_name" {
  value = module.lambda_api.lambda_exec_role_name
}
output "lambda_api_lambda_function_arn" {
  value = module.lambda_api.lambda_function_arn
}
output "lambda_api_lambda_function_name" {
  value = module.lambda_api.lambda_function_name
}