provider "aws" {
  region = "eu-west-1"
}

locals {
  common_tags = {
    Project   = "common-infra"
    ManagedBy = "Terraform"
  }
}
