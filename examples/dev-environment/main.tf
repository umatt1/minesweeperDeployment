provider "aws" {
  region = var.region
}

module "webapp" {
  source = "../../"

  application_name   = var.application_name
  environment        = var.environment
  region             = var.region
  availability_zones = var.availability_zones

  # Use development images
  server_image          = var.server_image
  client_image          = var.client_image
  server_container_port = var.server_container_port
  client_container_port = var.client_container_port

  # Database configuration for development
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password

  # Development environment might use smaller network settings
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs

  # For development, we might want to use cheaper infrastructure
  single_nat_gateway = var.single_nat_gateway

  tags = var.tags
} 