locals {
  repo_owner = split("/", var.github_repository)[0]
  repo_name  = split("/", var.github_repository)[1]
  repo_id    = "${local.repo_owner}-${local.repo_name}"

  azs = { for i, az in slice(data.aws_availability_zones.available.names, 0, var.az_count) : az => i }
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.project_name}-vpc"
    Project = var.project_name
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-igw"
    Project = var.project_name
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "main" {
  for_each                = local.azs
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone       = each.key
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-subnet-${each.value + 1}"
    Project = var.project_name
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${var.project_name}-rt"
    Project = var.project_name
  }
}

resource "aws_route_table_association" "main" {
  for_each       = local.azs
  subnet_id      = aws_subnet.main[each.key].id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "default" {
  name        = "${var.project_name}-vpc-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow internal traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-default-sg"
    Project = var.project_name
  }
}

resource "aws_ecr_repository" "main" {
  name                 = local.repo_id
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    Name = local.repo_id
    Project = var.project_name
  }
}

resource "aws_iam_role" "github_actions_role" {
  name = local.repo_id
  description = "IAM role for GitHub Actions to assume in AWS for repository: ${var.github_repository}"

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

  tags = {
    Name = "GitHub Actions Role - ${var.github_repository}"
    Project = var.project_name
  }
}

resource "aws_iam_role_policy" "github_actions_policy_ecr" {
  name = "${local.repo_id}_ECR"
  role = aws_iam_role.github_actions_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ECRPermissions"
        Effect = "Allow"
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:GetAuthorizationToken"
        ]
        Resource = "arn:aws:ecr:${var.aws_region}:${var.aws_account_id}:repository/${local.repo_id}"
      },
    ]
  })
}
