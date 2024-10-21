variable "project_name" {
  description = "Project name"
  type        = string
}

variable "vpc_id" {
  type        = string
  description = "VPC id"
}

variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "eu-west-1"
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "docker_repository_url" {
  description = "ECR url"
  type        = string
}

variable "docker_repository_arn" {
  description = "ECR ARN"
  type        = string
}

variable "lambda_image_tag" {
  description = "The tag of the Lambda Docker image"
  type        = string
  default     = "latest"
}

variable "lambda_env" {
  description = "Environment variables for lambda"
  type        = map(string)
  default     = {}
}

variable "log_retention" {
  type        = number
  description = "Number of days logs will be retained"
  default     = 14
}