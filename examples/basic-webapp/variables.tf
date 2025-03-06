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
  default     = "demo"
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
  default     = "exampledb"
}

variable "db_username" {
  type        = string
  description = "Username for database access"
  default     = "dbuser"
  sensitive   = true
}

variable "db_password" {
  type        = string
  description = "Password for database access"
  default     = "dbpassword"
  sensitive   = true
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to all resources"
  default = {
    Project     = "Example Deployment"
    ManagedBy   = "Terraform"
    Environment = "demo"
  }
} 