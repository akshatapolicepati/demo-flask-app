module "networking" {
  source = "./modules/networking"

  name_prefix = local.name_prefix
  common_tags = local.common_tags
}

module "alb" {
  source = "./modules/alb"

  name_prefix = local.name_prefix
  common_tags = local.common_tags

  vpc_id         = module.networking.vpc_id
  public_subnets = module.networking.public_subnets

  container_port = var.container_port
}
module "ecs" {
  source = "./modules/ecs"

  name_prefix = local.name_prefix
  common_tags = local.common_tags

  vpc_id         = module.networking.vpc_id
  public_subnets = module.networking.public_subnets

  alb_security_group_id = module.alb.alb_security_group_id
  target_group_arn      = module.alb.target_group_arn

  container_port = var.container_port

  cpu    = var.cpu
  memory = var.memory

  app_image = var.app_image

  aws_region = var.aws_region
}
