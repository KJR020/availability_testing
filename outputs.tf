output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.alb.alb_dns_name
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = module.ecs.ecs_cluster_name
}

output "ecs_service_name" {
  description = "ECS service name"
  value       = module.ecs.ecs_service_name
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.network.vpc_id
}

output "fis_experiment_template_id" {
  description = "FIS experiment template ID"
  value       = module.fis.fis_experiment_template_id
}