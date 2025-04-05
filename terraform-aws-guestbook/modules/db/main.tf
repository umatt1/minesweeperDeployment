locals {
  table_name = "guestbook_${var.environment}"
}

resource "aws_db_instance" "guestbook_server" {
  allocated_storage = 10
  instance_class    = "db.t3.micro"
  db_name           = var.db_name
  username          = var.db_username
  password          = var.db_password
  engine            = "postgres"
  engine_version    = "16.1"
  port              = 5432
  option_group_name = "default:postgres-16"
  # parameter_group_name = "postgres16"
  db_subnet_group_name = var.db_subnet_group_name

  publicly_accessible = false

  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.rds_security_group.id]

  tags = {
    Environment = var.environment
  }
}

resource "aws_security_group" "rds_security_group" {
  name        = "guestbook_rds_${var.environment}"
  description = "allow http access to rds"
  vpc_id      = var.vpc_id

  #depends_on = [aws_alb.guestbook]

  #ingress {
  #  protocol        = "-1"
  #  from_port       = 0
  #  to_port         = 0
  #  security_groups = [aws_security_group.guestbook.id] // not sure why ingress rule gets an array of sec groups
  #}

  #egress {
  #  protocol    = "-1"
  #  from_port   = 0
  #  to_port     = 0
  #  cidr_blocks = ["0.0.0.0/0"]
  #}

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Environment = var.environment
  }
}

/*
Allow an ECS task and the local dev user to read and write to RDS
*/
resource "aws_iam_role" "rds_data_access_role" {
  name               = "rds_data_access_role_${var.environment}"
  description        = "Provides write and read access to RDS data"
  assume_role_policy = data.aws_iam_policy_document.rds_data_role_assumption.json

  tags = {
    Environment = var.environment
  }
}

data "aws_iam_policy_document" "rds_data_role_assumption" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ecs-tasks.amazonaws.com"] # ECS tasks
      type        = "Service"
    }
    principals {
      identifiers = var.dev_user_arn == "" ? [] : [var.dev_user_arn] # Local user
      type        = "AWS"
    }
  }
}

resource "aws_iam_role_policy" "rds_data_access_policy" {
  name   = "rds_data_access_${var.environment}"
  role   = aws_iam_role.rds_data_access_role.id
  policy = data.aws_iam_policy_document.rds_data_access.json
}

data "aws_iam_policy_document" "rds_data_access" {
  statement {
    effect = "Allow"
    actions = [
      # RDS DataService permissions
      "rds-data:ExecuteSql",
      "rds-data:ExecuteStatement",
      "rds-data:BatchExecuteStatement",
      "rds-data:BeginTransaction",
      "rds-data:CommitTransaction",
      "rds-data:RollbackTransaction",

      # RDS DB connection permissions
      "rds-db:connect",

      # Secrets Manager permissions
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecrets",
      "secretsmanager:TagResource"
    ]
    resources = [
      aws_db_instance.guestbook_server.arn,
      "arn:aws:secretsmanager:*:*:secret:rds-db-credentials/*"
    ]
  }
}
