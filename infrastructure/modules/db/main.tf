locals {
  table_name     = "guestbook_${var.environment}"
}

resource "aws_db_instance" "guestbook_server" {
  allocated_storage = 10 #todo: allocated storage here
  instance_class = "db.t3.micro"
  db_name  = "todo: db name here"
  username = "todo: username here"
  password = "todo: password here"
  engine = "todo: engine here"
  engine_version = "todo: engine_version here"
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
      "dynamodb:CreateTable",
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:ListGlobalTables",
      "dynamodb:PutItem",
      "dynamodb:DescribeTable",
      "dynamodb:ListTables",
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:UpdateItem",
      "dynamodb:UpdateTable"
    ]
    resources = [
      aws_dynamodb_table.guestbook_server.arn
    ]
  }
}
