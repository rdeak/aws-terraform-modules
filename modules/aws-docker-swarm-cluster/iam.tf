
resource "aws_iam_role" "docker_swarm_node" {
  name = "docker_swarm_node"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "docker_swarm_node"
  }
}

resource "aws_iam_instance_profile" "docker_swarm_node" {
  name = "docker_swarm_node"
  role = aws_iam_role.docker_swarm_node.name
}

resource "aws_iam_policy" "docker_swarm_node_ecr" {
  name        = "docker_swarm_node_ecr"
  description = "Policy to allow EC2 instance to access ECR"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ]
        Resource = "*"
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
  tags = {
    Name = "docker_swarm_node_ecr"
  }
}

resource "aws_iam_role_policy_attachment" "docker_swarm_ecr" {
  role       = aws_iam_role.docker_swarm_node.name
  policy_arn = aws_iam_policy.docker_swarm_node_ecr.arn
}

resource "aws_iam_policy" "docker_swarm_node_ssm" {
  name = "docker_swarm_ssm"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParameterHistory",
          "ssm:PutParameter",
          "ssm:DeleteParameter",
        ],
        Effect   = "Allow",
        Resource = "arn:aws:ssm:*:*:parameter/docker-swarm/*"
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "docker_swarm_node_ssm" {
  role       = aws_iam_role.docker_swarm_node.name
  policy_arn = aws_iam_policy.docker_swarm_node_ssm.arn
}