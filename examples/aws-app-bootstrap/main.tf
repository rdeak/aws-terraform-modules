provider "aws" {
  region = "us-east-1"
}

module "bootstrap_app" {
  source            = "../../modules/aws-app-bootstrap"
  github_repository = "user/my-repo"
  aws_account_id    = "1234597890"
  aws_region        = "us-east-1"
  sg_name           = "my_sg"
}