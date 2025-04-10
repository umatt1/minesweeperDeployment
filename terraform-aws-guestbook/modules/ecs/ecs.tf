locals {
  server_container_name = "guestbook_server"
  client_container_name = "guestbook_client"
}

resource "aws_ecs_cluster" "guestbook" {
  name = "guestbook_${var.environment}"

  tags = {
    Environment = var.environment
  }
}

resource "aws_ecs_service" "guestbook_server" {
  name            = "guestbook_server_${var.environment}"
  cluster         = aws_ecs_cluster.guestbook.id
  task_definition = aws_ecs_task_definition.guestbook_server.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  health_check_grace_period_seconds = 120  # Give 2 minutes for the application to start

  load_balancer {
    target_group_arn = aws_alb_target_group.guestbook_server.arn
    container_name   = local.server_container_name
    container_port   = var.server_container_port
  }
  network_configuration {
    security_groups = [aws_security_group.guestbook_server.id]
    subnets         = var.private_subnets
  }
}

resource "aws_ecs_service" "guestbook_client" {
  name            = "guestbook_client_${var.environment}"
  cluster         = aws_ecs_cluster.guestbook.id
  task_definition = aws_ecs_task_definition.guestbook_client.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_alb_target_group.guestbook_client.arn
    container_name   = local.client_container_name
    container_port   = var.client_container_port
  }
  network_configuration {
    security_groups = [aws_security_group.guestbook_client.id]
    subnets         = var.private_subnets
  }
}

resource "aws_ecs_task_definition" "guestbook_server" {
  family                   = "guestbook-server-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.guestbook_task_execution.arn
  task_role_arn            = var.server_task_role_arn
  container_definitions    = <<DEFINITION
[
  {
    "image": "${var.server_image}",
    "cpu": 256,
    "memory": 512,
    "name": "${local.server_container_name}",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${var.server_container_port},
        "hostPort": ${var.server_container_port},
        "protocol": "tcp"
      }
    ],
    "environment": [
      {
        "name": "DB_USERNAME",
        "value": "${var.db_username}"
      },
      {
        "name": "DB_PASSWORD",
        "value": "${var.db_password}"
      },
      {
        "name": "DB_URL",
        "value": "jdbc:postgresql://${var.db_url}:5432/${var.db_name}"
      },  
      {
        "name": "SERVER_PORT",
        "value": "${var.server_container_port}"
      },
      {
        "name": "DYNAMO_TABLE",
        "value": "${var.dynamo_table_name}"
      },
      {
        "name": "AWS_REGION",
        "value": "${var.region}"
      },
      {
        "name": "CLIENT_ORIGIN",
        "value": "https://minesweeple.com"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-create-group": "true",
        "awslogs-group": "${aws_cloudwatch_log_group.guestbook_server.name}",
        "awslogs-region": "${var.region}",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
DEFINITION

  runtime_platform {
    cpu_architecture = "ARM64"
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_ecs_task_definition" "guestbook_client" {
  family                   = "guestbook-client-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.guestbook_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "guestbook_client"
      image     = var.client_image
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = tonumber(var.client_container_port)
          hostPort      = tonumber(var.client_container_port)
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "REACT_APP_SERVER_URL"
          value = "http://${aws_alb.guestbook.dns_name}"
        },
        {
          name  = "VITE_BACKEND_URL"
          value = "http://${aws_alb.guestbook.dns_name}"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/fargate/service/guestbook-client-${var.environment}"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  runtime_platform {
    cpu_architecture = "ARM64"
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "guestbook_server" {
  name = "/fargate/service/guestbook-server-${var.environment}"
  tags = {
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "guestbook_client" {
  name = "/fargate/service/guestbook-client-${var.environment}"
  tags = {
    Environment = var.environment
  }
}

resource "aws_security_group" "guestbook_server" {
  name        = "guestbook_server_${var.environment}"
  description = "Security group for server ECS tasks"
  vpc_id      = var.vpc_id

  depends_on = [aws_alb.guestbook]

  # Allow inbound traffic from ALB
  ingress {
    protocol        = "tcp"
    from_port       = var.server_container_port
    to_port         = var.server_container_port
    security_groups = [aws_security_group.guestbook.id]
    description     = "Allow inbound traffic from ALB"
  }

  # Allow outbound to RDS
  egress {
    protocol    = "tcp"
    from_port   = 5432
    to_port     = 5432
    cidr_blocks = ["10.0.21.0/24", "10.0.22.0/24"]  # Database subnets
    description = "Allow outbound to RDS"
  }

  # Allow outbound for DNS
  egress {
    protocol    = "udp"
    from_port   = 53
    to_port     = 53
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow DNS resolution"
  }

  # Allow outbound HTTPS for AWS API calls
  egress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS for AWS API calls"
  }

  tags = {
    Environment = var.environment
    Name        = "minesweeple-server-${var.environment}"
  }
}

resource "aws_security_group" "guestbook_client" {
  name        = "guestbook_client_${var.environment}"
  description = "Security group for client ECS tasks"
  vpc_id      = var.vpc_id

  depends_on = [aws_alb.guestbook]

  # Allow inbound traffic from ALB
  ingress {
    protocol        = "tcp"
    from_port       = var.client_container_port
    to_port         = var.client_container_port
    security_groups = [aws_security_group.guestbook.id]
    description     = "Allow inbound traffic from ALB"
  }

  # Allow outbound for DNS
  egress {
    protocol    = "udp"
    from_port   = 53
    to_port     = 53
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow DNS resolution"
  }

  # Allow outbound HTTPS for static assets and external resources
  egress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS for static assets and external resources"
  }

  tags = {
    Environment = var.environment
    Name        = "minesweeple-client-${var.environment}"
  }
}
