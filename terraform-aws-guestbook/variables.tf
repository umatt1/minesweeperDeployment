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