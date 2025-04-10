provider "aws" {
  region = "us-east-2"
}

module "guestbook" {
  source = "./../.."

  environment = "prod"
  region     = "us-east-2"

  # Database configuration
  db_name     = "guestbook"
  db_username = "admin"
  db_password = "change-me-in-production"  # In production, use AWS Secrets Manager or similar

  # Optional configurations with default values
  availability_zones    = ["us-east-2a", "us-east-2b"]
  client_image         = "brietsparks/guestbook-client:latest"
  server_image         = "brietsparks/guestbook-server:latest"
  client_container_port = 80
  server_container_port = 80

  # DNS Configuration
  domain_name = "guestbook.example.com"  # Using a subdomain
  create_route53_zone = false   # We'll use an existing zone
  route53_zone_id = "Z1234567890"  # This will need to be replaced with your actual zone ID
}

output "application_url" {
  description = "URL of the deployed application"
  value       = "https://${module.guestbook.alb_dns_host}"
}

output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.guestbook.vpc_id
} 