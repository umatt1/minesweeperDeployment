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
  default     = "prod"
}

variable "region" {
  type        = string
  description = "AWS region to deploy into"
  default     = "us-east-2"
}

variable "server_image" {
  type        = string
  description = "Docker image for the server application"
  default     = "your-account-id.dkr.ecr.us-east-2.amazonaws.com/server:latest"
}

variable "client_image" {
  type        = string
  description = "Docker image for the client application"
  default     = "your-account-id.dkr.ecr.us-east-2.amazonaws.com/client:latest"
}

variable "db_name" {
  type        = string
  description = "Name of the database"
  default     = "exampledb_prod"
}

variable "db_username" {
  type        = string
  description = "Username for database access"
  default     = "produser"
  sensitive   = true
}

variable "db_password" {
  type        = string
  description = "Password for database access"
  default     = "prodpassword"
  sensitive   = true
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for the public subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for the private subnets"
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "database_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for the database subnets"
  default     = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
}

variable "single_nat_gateway" {
  type        = bool
  description = "Whether to use a single NAT Gateway for all private subnets"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to all resources"
  default = {
    Project     = "Example Deployment"
    ManagedBy   = "Terraform"
    Environment = "prod"
    CostCenter  = "Production"
  }
} 