output "repository_url" {
  value = aws_ecr_repository.main.repository_url
}

output "repository_name" {
  value = aws_ecr_repository.main.name
}

output "role_name" {
  value = aws_iam_role.github_actions_role.name
}

output "role_name_arn" {
  value = aws_iam_role.github_actions_role.arn
}