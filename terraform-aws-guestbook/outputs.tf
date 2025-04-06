output "alb_dns_host" {
  description = "The DNS name of the application load balancer"
  value       = module.ecs.alb_dns_name
}

output "db_url" {
  description = "The connection URL for the database"
  value       = module.db.db_url
  sensitive   = true
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
} 