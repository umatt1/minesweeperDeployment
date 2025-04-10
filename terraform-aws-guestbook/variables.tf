variable "environment" {
  description = "The environment (e.g., prod, dev, staging)"
  type        = string
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-2"
}

variable "availability_zones" {
  description = "List of AWS availability zones"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "client_image" {
  description = "Docker image for the client application"
  type        = string
  default     = "brietsparks/guestbook-client"
}

variable "server_image" {
  description = "Docker image for the server application"
  type        = string
  default     = "brietsparks/guestbook-server"
}

variable "client_container_port" {
  description = "Port for the client container"
  type        = number
  default     = 80
}

variable "server_container_port" {
  description = "Port for the server container"
  type        = number
  default     = 80
}

variable "domain_name" {
  description = "Domain name for the application (e.g., example.com)"
  type        = string
  default     = null
}

variable "create_route53_zone" {
  description = "Whether to create a new Route 53 hosted zone"
  type        = bool
  default     = false
}

variable "route53_zone_id" {
  description = "ID of an existing Route 53 hosted zone to use"
  type        = string
  default     = null
}

variable "enable_dns" {
  description = "Whether to enable DNS configuration"
  type        = bool
  default     = true
} 