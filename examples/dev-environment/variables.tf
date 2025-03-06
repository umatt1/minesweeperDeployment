// Define the variables needed for the module
// These aren't used as inputs in the example, but are needed to fix linter errors

variable "application_name" {
  type        = string
  description = "The name of the application"
  default     = "example-app"
}

variable "environment" {
  type        = string
  description = "The deployment environment"
  default     = "dev"
}

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

variable "server_image" {
  type        = string
  description = "Docker image for the server application"
  default     = "your-account-id.dkr.ecr.us-east-2.amazonaws.com/server:dev"
}

variable "client_image" {
  type        = string
  description = "Docker image for the client application"
  default     = "your-account-id.dkr.ecr.us-east-2.amazonaws.com/client:dev"
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

variable "db_name" {
  type        = string
  description = "Name of the database"
  default     = "exampledb_dev"
}

variable "db_username" {
  type        = string
  description = "Username for database access"
  default     = "devuser"
  sensitive   = true
}

variable "db_password" {
  type        = string
  description = "Password for database access"
  default     = "devpassword"
  sensitive   = true
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for the public subnets"
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for the private subnets"
  default     = ["10.1.101.0/24", "10.1.102.0/24"]
}

variable "database_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for the database subnets"
  default     = ["10.1.21.0/24", "10.1.22.0/24"]
}

variable "single_nat_gateway" {
  type        = bool
  description = "Whether to use a single NAT Gateway for all private subnets"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to all resources"
  default = {
    Project     = "Example Deployment"
    ManagedBy   = "Terraform"
    Environment = "dev"
  }
} 