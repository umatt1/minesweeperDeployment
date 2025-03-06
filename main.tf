module "webapp" {
  source = "./infrastructure/modules/app"

  application_name      = var.application_name
  environment           = var.environment
  region                = var.region
  availability_zones    = var.availability_zones
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs
  enable_nat_gateway    = var.enable_nat_gateway
  single_nat_gateway    = var.single_nat_gateway
  server_image          = var.server_image
  client_image          = var.client_image
  server_container_port = var.server_container_port
  client_container_port = var.client_container_port
  db_name               = var.db_name
  db_username           = var.db_username
  db_password           = var.db_password
  tags                  = var.tags
} 