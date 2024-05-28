variable "user" {
  description = "Mongo username."
  type        = string
}

variable "pass" {
  description = "Mongo password."
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
  default     = "mongo:7.0.9"
}
