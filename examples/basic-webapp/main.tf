provider "aws" {
  region = "us-east-2"
}

module "webapp" {
  source = "../../"

  application_name = var.application_name
  environment      = var.environment

  # Container images - replace with your actual images
  server_image = var.server_image
  client_image = var.client_image

  # Database configuration
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password

  tags = var.tags
} 