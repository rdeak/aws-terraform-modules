output "docker_swarm_address" {
  description = "Swarm bastion IP"
  value       = aws_instance.docker_swarm_leader.public_ip
}

output "ssh_sg_id" {
  description = "Security group id for SSH access"
  value       = aws_security_group.docker_swarm_ssh.id
}

output "apps_sg_id" {
  description = "Security group id used for allowing access to apps in Docker Swarm"
  value       = aws_security_group.docker_swarm_apps.id
}