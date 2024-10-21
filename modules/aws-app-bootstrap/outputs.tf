output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_subnet_ids_by_az" {
  description = "List of IDs of public subnets"
  value = {
    for az, subnet in aws_subnet.main : az => subnet.id
  }
}

output "vpc_subnet_ids" {
  description = "List of IDs of public subnets"
  value = values(aws_subnet.main)[*].id
}

output "vpc_security_group_id" {
  description = "ID of the default security group"
  value       = aws_security_group.default.id
}

output "vpc_security_group_name" {
  description = "ID of the default security group"
  value       = aws_security_group.default.name
}

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