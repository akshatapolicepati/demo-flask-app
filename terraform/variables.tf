variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "environment" {
  type        = string
  description = "Deployment Environment"
}

variable "project_name" {
  type        = string
  description = "Project Name"
}

variable "container_port" {
  type        = number
  description = "Application Container Port"
}

variable "cpu" {
  type = number
}

variable "memory" {
  type = number
}

variable "app_image" {
  type        = string
  description = "Container image"
}
