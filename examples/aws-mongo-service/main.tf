locals {
  aws_region = "us-east-1"
}

provider "aws" {
  region = local.aws_region
}

terraform {
  backend "s3" {
    key = "global/aws-mongo-service/terraform.tfstate"
  }
}

module "mongo" {
  source = "../../modules/aws-mongo-service"
  user   = "user"
  pass   = "pass"
}

output "host" {
  value = module.mongo.service_url
}
