variable "environment" {
  type = string
  description = "the environment"
}

# todo: update me to postgres
variable "read_capacity" {
  type        = string
  description = "the dynamo read throughput"
}

variable "write_capacity" {
  type        = string
  description = "the dynamo write throughput"
}

variable "dev_user_arn" {
  type = string
  description = "the arn of the IAM user for local development"
  default = ""
}
