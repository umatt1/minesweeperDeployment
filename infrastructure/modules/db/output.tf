output "role_arn" {
  description = "the arn of the role to be assumed when accessing the database"
  value = aws_iam_role.dynamodb_data_access_role.arn
}

output "role_id" {
  description = "the id of the role to be assumed when accessing the database"
  value = aws_iam_role_policy.dynamodb_data_access.id
}

# output "table_name" {
#   description = "the DynamoDB table name"
#   value = local.table_name
# }

output "db_url" {
  description = "url"
  value = aws_db_instance.guestbook_server.address
}