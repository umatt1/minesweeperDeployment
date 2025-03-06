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
  region = var.region
}

module "webapp" {
  source = "../../modules/app"

  application_name   = "minesweeper"
  environment        = "dev"
  region             = var.region
  availability_zones = var.availability_zones

  # Use local development images or override with your own
  server_image          = var.server_image
  client_image          = var.client_image
  server_container_port = var.server_container_port
  client_container_port = var.client_container_port

  # Database configuration - use less secure defaults for dev
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password

  # Development environment might use smaller network settings
  vpc_cidr              = "10.1.0.0/16" # Different from prod
  public_subnet_cidrs   = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnet_cidrs  = ["10.1.101.0/24", "10.1.102.0/24"]
  database_subnet_cidrs = ["10.1.21.0/24", "10.1.22.0/24"]

  # For development, we might want to use cheaper infrastructure
  single_nat_gateway = true

  tags = {
    Project     = "Minesweeper Deployment"
    ManagedBy   = "Terraform"
    Environment = "dev"
  }
}
