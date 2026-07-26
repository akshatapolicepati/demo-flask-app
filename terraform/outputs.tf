output "environment" {
  value = var.environment
}

output "project_name" {
  value = var.project_name
}

output "vpc_id" {
  value = module.networking.vpc_id
}

output "public_subnets" {
  value = module.networking.public_subnets
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "alb_security_group_id" {
  value = module.alb.alb_security_group_id
}

output "target_group_arn" {
  value = module.alb.target_group_arn
}
output "ecs_cluster_name" {
  value = module.ecs.ecs_cluster_name
}

output "ecs_service_name" {
  value = module.ecs.ecs_service_name
}
