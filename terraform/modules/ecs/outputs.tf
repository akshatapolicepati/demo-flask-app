output "ecs_cluster_name" {
  value = aws_ecs_cluster.vpc-tf.name
}

output "ecs_service_name" {
  value = aws_ecs_service.vpc-tf.name
}
