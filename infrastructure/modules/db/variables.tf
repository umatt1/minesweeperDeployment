variable "environment" {
  type        = string
  description = "the environment"
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

variable "dev_user_arn" {
  type        = string
  description = "the arn of the IAM user for local development"
  default     = ""
}

variable "db_subnet_group_name" {
  type        = string
  description = "name of the DB subnet group"
}

variable "vpc_id" {
  type        = string
  description = "the id of the vpc to run the ECS cluster in"
}