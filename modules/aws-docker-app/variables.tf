variable "container_name" {
  description = "The name for the container service."
  type        = string
}

variable "container_size" {
  description = "The power specification for the container service."
  type        = string
  default     = "nano"
}

variable "image_name" {
  description = "Docker image name."
  type        = string
}

variable "repository_name" {
  description = "Repository name."
  type        = string
  default     = ""
}