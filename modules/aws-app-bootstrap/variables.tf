variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
}

variable "aws_account_id" {
  description = "The AWS account ID where resources will be created."
  type        = string
}

variable "github_repository" {
  description = "The GitHub repository in the format 'owner/repo'."
  type        = string
}

variable "branch_name" {
  description = "The branch name to allow for OIDC authentication."
  type        = string
  default     = "*"
}

