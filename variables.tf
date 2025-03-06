// Required variables
variable "environment" {
  type        = string
  description = "The deployment environment (e.g., dev, test, prod)"
}

variable "application_name" {
  type        = string
  description = "The name of the application"
  default     = "webapp"
}

// Network variables
variable "region" {
  type        = string
  description = "AWS region to deploy into"
  default     = "us-east-2"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of AWS availability zones in the region"
  default     = ["us-east-2a", "us-east-2b"]
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for the public subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for the private subnets"
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "database_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for the database subnets"
  default     = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Whether to enable NAT Gateway"
  default     = true
}

variable "single_nat_gateway" {
  type        = bool
  description = "Whether to use a single NAT Gateway for all private subnets"
  default     = true
}

// Application variables
variable "server_image" {
  type        = string
  description = "Docker image for the server application"
}

variable "client_image" {
  type        = string
  description = "Docker image for the client application"
}

variable "server_container_port" {
  type        = number
  description = "Port that the server application listens on"
  default     = 80
}

variable "client_container_port" {
  type        = number
  description = "Port that the client application listens on"
  default     = 80
}

// Database variables
variable "db_name" {
  type        = string
  description = "Name of the database"
  default     = "appdb"
}

variable "db_username" {
  type        = string
  description = "Username for database access"
  sensitive   = true
}

variable "db_password" {
  type        = string
  description = "Password for database access"
  sensitive   = true
}

// Tagging
variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to all resources"
  default     = {}
} 