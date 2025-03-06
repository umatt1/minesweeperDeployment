output "client_url" {
  description = "The URL of the client application"
  value       = module.webapp.client_url
}

output "server_url" {
  description = "The URL of the server API"
  value       = module.webapp.server_url
}

output "db_endpoint" {
  description = "The endpoint of the database"
  value       = module.webapp.db_endpoint
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.webapp.vpc_id
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.webapp.public_subnets
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.webapp.private_subnets
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.webapp.database_subnets
} 