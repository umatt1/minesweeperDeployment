variable "vpc_id" {
  description = "The VPC ID where the database will be deployed"
  type        = string
}

resource "aws_iam_user" "local_dev_user" {
  name = var.local_user_name
}

resource "aws_iam_access_key" "local_dev_user" {
  user = aws_iam_user.local_dev_user.name
}

locals {
  environment = "dev"
}

provider "aws" {
  #profile = var.profile
  region  = var.region
}

module "db" {
  source = "../../modules/db"
  providers = {
    aws = aws
  }

  environment = local.environment
  db_subnet_group_name = "dev-db-subnet-group"
  vpc_id = var.vpc_id
  dev_user_arn = aws_iam_user.local_dev_user.arn
}
