output "state_bucket_arn" {
  value = aws_s3_bucket.terraform_state.arn
  description = "S3 Bucket ARN where state files is persisted"
}

output "state_locks_table" {
  value = aws_dynamodb_table.terraform_locks.name
  description = "Dynamo DB name where state locks is saved"
}

output "state_locks_table_arn" {
  value = aws_dynamodb_table.terraform_locks.arn
  description = "Dynamo DB ARN where state locks is saved"
}