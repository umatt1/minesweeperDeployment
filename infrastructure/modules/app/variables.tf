//
// required
//
# variable "profile" {
#   type        = string
#   description = "an aws profile to act on behalf of terraform"
# }

variable "environment" {
  type = string
  description = "the environment"
}

//
// optional
//
variable "region" {
  type        = string
  description = "an aws region"
  default     = "us-east-2"
}

variable "availability_zones" {
  type        = list(string)
  description = "array of aws availability zones of the provided region"
  default     = ["us-east-2a", "us-east-2b"]
}

variable "server_image" {
  type        = string
  description = "image name of the server app"
  default     = "580548589113.dkr.ecr.us-east-2.amazonaws.com/sweeper"
}

variable "client_image" {
  type        = string
  description = "image name of the client app"
  default     = "580548589113.dkr.ecr.us-east-2.amazonaws.com/sweeperfront"
}

variable "server_container_port" {
  type        = string
  description = "the port that the server serves from"
  default     = 8080
}

variable "client_container_port" {
  type        = string
  description = "the port that the client serves from"
  default     = 5173
}

variable "local_user_name" {
  type = string
  description = "the name of the IAM user for local development"
  default = "local_dev_user"
}

variable "db_name" {
  type = string
  description = "the name of the postgres db"
  default = "minesweeperdb"
}

variable "db_username" {
  type = string
  description = "the username for the db"
  default = "minesweeperuser"
}

variable "db_password" {
  type = string
  description = "the password for the db"
  default = "minesweeperpassword"
}
