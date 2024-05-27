provider "aws" {
  region = "us-east-1"
}

# once deployed you can use backend like this:
#terraform {
#  backend "s3" {
#    key            = "global/terraform-s3-backend/terraform.tfstate"
#  }
#}

module "s3_backend" {
  source            = "../../modules/terraform-s3-backend"
  bucket_name       = "my-terraform-states"
}