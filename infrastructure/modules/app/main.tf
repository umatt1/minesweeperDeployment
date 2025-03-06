provider "aws" {
  #profile = var.profile
  region = var.region
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.application_name}_${var.environment}"
  cidr = var.vpc_cidr

  azs              = var.availability_zones
  public_subnets   = var.public_subnet_cidrs
  private_subnets  = var.private_subnet_cidrs
  database_subnets = var.database_subnet_cidrs

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  tags = merge(var.tags, {
    Environment = var.environment
    Name        = "${var.application_name}-vpc-${var.environment}"
  })
}

module "db" {
  source = "../db"
  providers = {
    aws = aws
  }

  environment          = var.environment
  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
  db_subnet_group_name = module.vpc.database_subnet_group
  vpc_id               = module.vpc.vpc_id

  tags = merge(var.tags, {
    Environment = var.environment
    Name        = "${var.application_name}-db-${var.environment}"
  })
}

module "ecs" {
  source = "../ecs"
  providers = {
    aws = aws
  }

  environment      = var.environment
  application_name = var.application_name

  client_container_port = var.client_container_port
  client_image          = var.client_image
  private_subnets       = module.vpc.private_subnets
  public_subnets        = module.vpc.public_subnets
  region                = var.region
  server_container_port = var.server_container_port
  server_image          = var.server_image
  server_task_role_arn  = module.db.role_arn
  vpc_id                = module.vpc.vpc_id
  dynamo_table_name     = var.db_name
  db_name               = var.db_name
  db_username           = var.db_username
  db_password           = var.db_password
  db_url                = module.db.db_url

  tags = merge(var.tags, {
    Environment = var.environment
    Name        = "${var.application_name}-ecs-${var.environment}"
  })
}
