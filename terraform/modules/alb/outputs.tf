output "alb_dns_name" {
  value = aws_lb.vpc-tf.dns_name
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "target_group_arn" {
  value = aws_lb_target_group.vpc-tf.arn
}

