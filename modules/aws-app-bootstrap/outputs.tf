output "docker_repository_url" {
  value = aws_ecr_repository.main.repository_url
}

output "docker_repository_name" {
  value = aws_ecr_repository.main.name
}

output "docker_repository_arn" {
  value = aws_ecr_repository.main.arn
}

output "github_role_name" {
  value = aws_iam_role.github_actions_role.name
}

output "github_role_arn" {
  value = aws_iam_role.github_actions_role.arn
}

output "github_role_id" {
  value = aws_iam_role.github_actions_role.id
}