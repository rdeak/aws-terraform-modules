variable "project_name" {
  description = "Name of the project for tagging"
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

variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "eu-west-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "az_count" {
  description = "Number of AZs to use"
  default     = 2
}