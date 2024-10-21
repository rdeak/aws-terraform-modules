output "lambda_exec_role_id" {
  description = "Id of the lambda exec role"
  value = aws_iam_role.lambda_exec_role.id
}

output "lambda_exec_role_name" {
  description = "Name of the lambda exec role"
  value = aws_iam_role.lambda_exec_role.name
}

output "lambda_exec_role_arn" {
  description = "ARN of the lambda exec role"
  value = aws_iam_role.lambda_exec_role.arn
}

output "lambda_function_arn" {
  description = "ARN of the lambda function"
  value = aws_lambda_function.lambda_function.arn
}

output "lambda_function_name" {
  description = "ARN of the lambda function"
  value = aws_lambda_function.lambda_function.function_name
}

output "api_endpoint" {
  description = "Invoke URL of the API Gateway"
  value       = aws_apigatewayv2_api.api_gateway.api_endpoint
}

output "lambda_sg_id" {
  value = aws_security_group.lambda_sg.id
}