variable "ports" {
  type = list(tuple([string, number]))
  description = "A list of ports. First value is protocol and second one is port"
}

variable "app_sg_name" {
  description = "Security group name for apps"
  type        = string
  default     = "docker_swarm_apps"
}
