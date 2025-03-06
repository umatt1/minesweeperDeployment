provider "aws" {
  region = var.region
}

module "webapp" {
  source = "../../"

  application_name = var.application_name
  environment      = var.environment

  # Use production images
  server_image = var.server_image
  client_image = var.client_image

  # Database configuration for production
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password

  # Production environment uses full network settings
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs

  # For production, we want high availability
  single_nat_gateway = var.single_nat_gateway

  tags = var.tags
} 