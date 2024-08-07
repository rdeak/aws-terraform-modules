locals {
  repo_owner = split("/", var.github_repository)[0]
  repo_name  = split("/", var.github_repository)[1]
  repo_id    = "${local.repo_owner}-${local.repo_name}"
}

resource "aws_ecr_repository" "main" {
  name                 = local.repo_id
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    Name = local.repo_id
  }
}

resource "aws_iam_role" "github_actions_role" {
  name = local.repo_id

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${var.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          },
          StringLike = {
            "token.actions.githubusercontent.com:sub" : "repo:${var.github_repository}:ref:refs/heads/${var.branch_name}"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "github_actions_policy" {
  name = local.repo_id
  role = aws_iam_role.github_actions_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Resource = "arn:aws:ecr:${var.aws_region}:${var.aws_account_id}:repository/${local.repo_id}"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeSecurityGroups",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:ResourceTag/Name" = var.sg_name
          }
        }
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      }
    ]
  })
}
