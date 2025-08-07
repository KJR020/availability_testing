output "fis_experiment_template_id" {
  description = "FIS experiment template ID"
  value       = aws_fis_experiment_template.stop_ecs_tasks.id
}

output "fis_execution_role_arn" {
  description = "FIS execution role ARN"
  value       = aws_iam_role.fis_execution.arn
}

output "fis_log_group_name" {
  description = "FIS CloudWatch log group name"
  value       = aws_cloudwatch_log_group.fis.name
}

output "fis_log_group_arn" {
  description = "FIS CloudWatch log group ARN"
  value       = aws_cloudwatch_log_group.fis.arn
}