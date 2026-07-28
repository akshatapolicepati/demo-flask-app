resource "aws_cloudwatch_log_group" "vpc-tf" {
  name              = "/ecs/${var.name_prefix}"
  retention_in_days = 14

  tags = var.common_tags
}

resource "aws_ecs_cluster" "vpc-tf" {
  name = "${var.name_prefix}-cluster"

  tags = var.common_tags
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.name_prefix}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role = aws_iam_role.ecs_task_execution_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_security_group" "ecs" {
  name        = "${var.name_prefix}-ecs-sg"
  description = "ECS Security Group"

  vpc_id = var.vpc_id

  ingress {
    from_port = var.container_port
    to_port   = var.container_port

    protocol = "tcp"

    security_groups = [
      var.alb_security_group_id
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.common_tags
}

resource "aws_ecs_task_definition" "vpc-tf" {
  family                   = "${var.name_prefix}-task"
  requires_compatibilities = ["FARGATE"]

  network_mode = "awsvpc"

  cpu    = var.cpu
  memory = var.memory

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "expense-tracker"
      image     = var.app_image
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.vpc-tf.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = var.common_tags
}

resource "aws_ecs_service" "vpc-tf" {
  name            = "${var.name_prefix}-service"
  cluster         = aws_ecs_cluster.vpc-tf.id
  task_definition = aws_ecs_task_definition.vpc-tf.arn

  desired_count = 3

  deployment_maximum_percent = 200

  deployment_minimum_healthy_percent = 100

  health_check_grace_period_seconds = 60

  launch_type = "FARGATE"

  network_configuration {
    subnets = var.public_subnets

    security_groups = [
      aws_security_group.ecs.id
    ]

    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn

    container_name = "expense-tracker"

    container_port = var.container_port
  }

  depends_on = [
    aws_iam_role_policy_attachment.ecs_task_execution_role
  ]

  tags = var.common_tags
}
