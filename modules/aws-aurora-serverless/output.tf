output "connection_url" {
  value = format(
    "postgresql://%s:%s@%s:%s/%s",
    aws_rds_cluster.default.master_username,
    aws_rds_cluster.default.master_password,
    aws_rds_cluster.default.endpoint,
    aws_rds_cluster.default.port,
    aws_rds_cluster.default.database_name
  )
  sensitive = true
}

output "reader_url" {
  value = aws_rds_cluster.default.reader_endpoint
}

output "writer_url" {
  value = aws_rds_cluster.default.endpoint
}

output "cluster_arn" {
  value = aws_rds_cluster.default.arn
}

output "security_group_id" {
  description = "DB security group id"
  value = aws_security_group.default.id
}