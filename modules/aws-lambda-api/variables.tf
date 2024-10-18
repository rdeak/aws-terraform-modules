variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "docker_repository_url" {
  description = "ECR url"
  type = string
}

variable "docker_repository_arn" {
  description = "ECR ARN"
  type = string
}

variable "lambda_image_tag" {
  description = "The tag of the Lambda Docker image"
  type        = string
  default     = "latest"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "my-project"
}
