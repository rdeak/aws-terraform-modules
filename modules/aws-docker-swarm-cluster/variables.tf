variable "ami" {
  description = "AMI"
  type        = string
  default     = "ami-05842291b9a0bd79f"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3a.nano"
}

variable "key_name" {
  description = "SSH Key Pair name"
  type        = string
  default     = "swarm"
}

variable "total_managers" {
  description = "Odd number of total managers"
  type        = number
  default     = 3
  validation {
    condition     = (var.total_managers % 2) != 0 && var.total_managers >= 1
    error_message = "The number must be odd number greater then 0."
  }
}
