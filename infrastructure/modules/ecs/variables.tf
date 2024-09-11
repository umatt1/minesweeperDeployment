variable "region" {
  type        = string
  description = "an aws region"
}

variable "environment" {
  type = string
  description = "the environment"
}

variable "vpc_id" {
  type = string
  description = "the id of the vpc to run the ECS cluster in"
}

variable "private_subnets" {
  type = list(string)
  description = "a list of cidr ranges of the private subnets to run the ECS tasks in"
}

variable "public_subnets" {
  type = list(string)
  description = "a list of cidr ranges of the public subnets for the load balancer"
}

variable "server_task_role_arn" {
  type = string
  description = "the role arn for the server ECS task"
}

variable "server_image" {
  type        = string
  description = "580548589113.dkr.ecr.us-east-2.amazonaws.com/sweeper"
}

variable "client_image" {
  type        = string
  description = "580548589113.dkr.ecr.us-east-2.amazonaws.com/sweeperfront2"
}

variable "server_container_port" {
  type        = string
  description = "the port that the server serves from"
}

variable "client_container_port" {
  type        = string
  description = "the port that the client serves from"
}

variable "dynamo_table_name" {
  type = string
  description = "the DynamoDB table that the server talks to"
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

variable "db_url" {
  type = string
  description = "url for the db"
}

variable "db_name"{
  type = string
  description = "the name of the db"
}