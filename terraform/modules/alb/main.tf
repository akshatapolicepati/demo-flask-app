resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-alb-sg"
  description = "ALB Security Group"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-alb-sg"
    }
  )
}

resource "aws_lb" "vpc-tf" {

  name               = "${var.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = var.public_subnets

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-alb"
    }
  )
}

resource "aws_lb_target_group" "vpc-tf" {

  name        = substr("${var.name_prefix}-tg", 0, 32)
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"

  vpc_id = var.vpc_id

  health_check {

    path = "/health"

    matcher = "200"

    protocol = "HTTP"

    interval = 30

    timeout = 5

    healthy_threshold = 2

    unhealthy_threshold = 3
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-tg"
    }
  )
}

resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.vpc-tf.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.vpc-tf.arn
  }
}
