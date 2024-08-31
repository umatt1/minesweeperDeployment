locals {
  table_name     = "guestbook_${var.environment}"
}

resource "aws_db_instance" "guestbook_server" {
  allocated_storage = 10
  instance_class = "db.t3.micro"
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  engine = "postgres"
  engine_version = "16.1"
  port = 5432
  option_group_name = "default:postgres-16"
  parameter_group_name = "postgres16"
  
  skip_final_snapshot = true

  tags = {
    Environment = var.environment
  }
}

/*
Allow an ECS task and the local dev user to read and write to RDS
*/
resource "aws_iam_role" "dynamodb_data_access_role" {
  name               = "dynamodb_data_access_role_${var.environment}"
  description        = "Provides write and read access to DynamoDB data"
  assume_role_policy = data.aws_iam_policy_document.dynamo_db_data_role_assumption.json

  tags = {
    Environment = var.environment
  }
}

data "aws_iam_policy_document" "dynamo_db_data_role_assumption" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
    principals {
      identifiers = var.dev_user_arn == "" ? [] : [var.dev_user_arn]
      type = "AWS"
    }
  }
}

resource "aws_iam_role_policy" "dynamodb_data_access" {
  name   = "dynamodb_data_access_${var.environment}"
  role   = aws_iam_role.dynamodb_data_access_role.id
  policy = data.aws_iam_policy_document.dynamodb_data_access.json
}

data "aws_iam_policy_document" "dynamodb_data_access" {
  statement {
    effect = "Allow"
    actions = [
        "dbqms:CreateFavoriteQuery",
        "dbqms:DescribeFavoriteQueries",
        "dbqms:UpdateFavoriteQuery",
        "dbqms:DeleteFavoriteQueries",
        "dbqms:GetQueryString",
        "dbqms:CreateQueryHistory",
        "dbqms:DescribeQueryHistory",
        "dbqms:UpdateQueryHistory",
        "dbqms:DeleteQueryHistory",
        "rds-data:ExecuteSql",
        "rds-data:ExecuteStatement",
        "rds-data:BatchExecuteStatement",
        "rds-data:BeginTransaction",
        "rds-data:CommitTransaction",
        "rds-data:RollbackTransaction",
        "secretsmanager:CreateSecret",
        "secretsmanager:ListSecrets",
        "secretsmanager:GetRandomPassword",
        "tag:GetResources",
        "secretsmanager:GetSecretValue",
        "secretsmanager:PutResourcePolicy",
        "secretsmanager:PutSecretValue",
        "secretsmanager:DeleteSecret",
        "secretsmanager:DescribeSecret",
        "secretsmanager:TagResource"
      ]
    resources = [
      aws_db_instance.guestbook_server.arn,
      "arn:aws:secretsmanager:*:*:secret:rds-db-credentials/*"
    ]
  }
}
