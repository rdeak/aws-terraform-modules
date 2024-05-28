resource "aws_lightsail_container_service" "main" {
  name        = var.container_name
  power       = var.container_size
  scale       = 1
  is_disabled = false

  tags = {
    Name = var.container_name
  }

  private_registry_access {
    ecr_image_puller_role {
      is_active = true
    }
  }
}

data "aws_iam_policy_document" "default" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [
        aws_lightsail_container_service.main.private_registry_access[0].ecr_image_puller_role[0].principal_arn
      ]
    }

    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
    ]
  }
}


data "aws_ecr_repository" "service_repo" {
  name = var.repository_name
}

resource "aws_ecr_repository_policy" "default" {
  repository = data.aws_ecr_repository.service_repo.name
  policy     = data.aws_iam_policy_document.default.json
}