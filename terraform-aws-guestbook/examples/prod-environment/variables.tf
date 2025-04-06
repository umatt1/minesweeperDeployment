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
  default     = "580548589113.dkr.ecr.us-east-2.amazonaws.com/sweeper:latest"
}

variable "client_image" {
  type        = string
  description = "image name of the client app"
  default     = "580548589113.dkr.ecr.us-east-2.amazonaws.com/sweeperfront2:latest"
}

variable "server_container_port" {
  type        = string
  description = "the port that the server serves from"
  default     = 80
}

variable "client_container_port" {
  type        = string
  description = "the port that the client serves from"
  default     = 80
}

variable "db_name" {
  type        = string
  description = "the name of the postgres db"
  default     = "minesweeperdb"
}

variable "db_username" {
  type        = string
  description = "the username for the db"
  default     = "minesweeperuser"
}

variable "db_password" {
  type        = string
  description = "the password for the db"
  default     = "minesweeperpassword"
}
