provider "aws" {
  region = "us-east-2"
}

module "guestbook" {
  source = "./../.."

  environment = "prod"
  region     = "us-east-2"

  # Database configuration
  db_name     = "guestbook"
  db_username = "guestbookadmin"
  db_password = "Guestbook123!"  # More secure password for testing

  # Optional configurations with default values
  availability_zones    = ["us-east-2a", "us-east-2b"]
  client_image         = "brietsparks/guestbook-client:latest"
  server_image         = "brietsparks/guestbook-server:latest"
  client_container_port = 80
  server_container_port = 80
}

output "application_url" {
  description = "URL of the deployed application"
  value       = "http://${module.guestbook.alb_dns_host}"
}

output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.guestbook.vpc_id
} 