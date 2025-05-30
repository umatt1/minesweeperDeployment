provider "aws" {
  region = var.region
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "guestbook_${var.environment}"
  cidr = "10.0.0.0/16"

  azs              = var.availability_zones
  public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  database_subnets = ["10.0.21.0/24", "10.0.22.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Environment = var.environment
    Terraform   = "true"
    Module      = "guestbook"
  }
}

module "db" {
  source = "./modules/db"

  environment          = var.environment
  db_name             = var.db_name
  db_username         = var.db_username
  db_password         = var.db_password
  db_subnet_group_name = module.vpc.database_subnet_group
  vpc_id              = module.vpc.vpc_id
}

module "ecs" {
  source = "./modules/ecs"

  environment          = var.environment
  client_container_port = var.client_container_port
  client_image         = var.client_image
  private_subnets      = module.vpc.private_subnets
  public_subnets       = module.vpc.public_subnets
  region               = var.region
  server_container_port = var.server_container_port
  server_image         = var.server_image
  server_task_role_arn = module.db.role_arn
  vpc_id               = module.vpc.vpc_id
  dynamo_table_name    = var.db_name
  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
  db_url               = module.db.db_url
  domain_name          = var.domain_name
  create_route53_zone  = var.create_route53_zone
  route53_zone_id      = var.route53_zone_id
} 