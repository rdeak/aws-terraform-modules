locals {
  aws_region = "us-east-1"
}

provider "aws" {
  region = local.aws_region
}

module "app" {
  source            = "../../modules/aws-app-bootstrap"
  github_repository = "rdeak/match-broadcast-sse"
  aws_account_id    = "123456789012"
  aws_region        = local.aws_region
}