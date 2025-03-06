module "webapp" {
  source = "../../modules/app"

  application_name   = "minesweeper"
  environment        = "prod"
  region             = var.region
  availability_zones = var.availability_zones

  # Container images
  server_image          = var.server_image
  client_image          = var.client_image
  server_container_port = var.server_container_port
  client_container_port = var.client_container_port

  # Database configuration
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password

  # Optional network configuration
  # vpc_cidr            = "10.0.0.0/16"
  # public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  # private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
  # database_subnet_cidrs = ["10.0.21.0/24", "10.0.22.0/24"]

  tags = {
    Project     = "Minesweeper Deployment"
    ManagedBy   = "Terraform"
    Environment = "prod"
  }
}
