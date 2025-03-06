//
// required
//
# variable "profile" {
#   type        = string
#   description = "an aws profile to act on behalf of terraform"
# }

//
// optional
//
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
  default     = "580548589113.dkr.ecr.us-east-2.amazonaws.com/sweeper:latest"
}

variable "client_image" {
  type        = string
  description = "Docker image for the client application"
  default     = "580548589113.dkr.ecr.us-east-2.amazonaws.com/sweeperfront2:latest"
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
  default     = "minesweeperdb"
}

variable "db_username" {
  type        = string
  description = "Username for database access"
  default     = "minesweeperuser"
  sensitive   = true
}

variable "db_password" {
  type        = string
  description = "Password for database access"
  default     = "minesweeperpassword"
  sensitive   = true
}
