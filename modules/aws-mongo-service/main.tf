locals {
  service_name = replace(var.image_name, "/[^A-Za-z0-9]/", "-")
}

resource "aws_lightsail_container_service" "main" {
  name  = local.service_name
  power = "nano"
  scale = 1
}

resource "aws_lightsail_container_service_deployment_version" "main" {
  service_name = aws_lightsail_container_service.main.name

  container {
    container_name = "mongodb"
    image          = var.image_name

    environment = {
      MONGO_INITDB_ROOT_USERNAME = var.user
      MONGO_INITDB_ROOT_PASSWORD = var.pass
    }

    ports = {
      27017 = "TCP"
    }
  }
}
