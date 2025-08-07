variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "availability-test"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "test"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "app_port" {
  description = "Application port"
  type        = number
  default     = 80
}

variable "fis_target_availability_zones" {
  description = "Availability zones to target for FIS experiments (leave empty to target all AZs)"
  type        = list(string)
  default     = []
}
