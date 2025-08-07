variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "ecs_cluster_arn" {
  description = "ECS cluster ARN"
  type        = string
}

variable "ecs_service_name" {
  description = "ECS service name"
  type        = string
}

variable "experiment_description" {
  description = "FIS experiment description"
  type        = string
  default     = "Stop ECS tasks to test application resilience"
}

variable "action_description" {
  description = "FIS action description"
  type        = string
  default     = "Stop half of the ECS tasks"
}

variable "task_stop_percentage" {
  description = "Percentage of tasks to stop"
  type        = number
  default     = 50
}

variable "target_availability_zones" {
  description = "List of availability zones to target for the experiment (optional, if empty targets all AZs)"
  type        = list(string)
  default     = []
}

variable "log_retention_days" {
  description = "Log retention days for FIS logs"
  type        = number
  default     = 7
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
