provider "aws" {
  region = var.aws_region
}

locals {
  stage = terraform.workspace
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.lambda_function_name}-${local.stage}-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Stage   = local.stage
    Project = var.project_name
  }
}

resource "aws_iam_role_policy" "lambda_policy_ecr" {
  name = "${var.lambda_function_name}-${local.stage}-ecr"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = var.docker_repository_arn
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy_logs" {
  name = "${var.lambda_function_name}-${local.stage}-logs"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "lambda_function" {
  function_name = "${var.lambda_function_name}-${local.stage}"
  role          = aws_iam_role.lambda_exec_role.arn
  package_type  = "Image"
  image_uri     = "${var.docker_repository_url}:${var.lambda_image_tag}"

  tags = {
    Stage   = local.stage
    Project = var.project_name
  }
}

resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "${var.lambda_function_name}-${local.stage}-api"
  protocol_type = "HTTP"

  tags = {
    Stage   = local.stage
    Project = var.project_name
  }
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.api_gateway.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.lambda_function.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "default_route" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "stage" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = local.stage
  auto_deploy = true

  tags = {
    Stage   = local.stage
    Project = var.project_name
  }
}

resource "aws_lambda_permission" "api_gateway_invoke_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api_gateway.execution_arn}/${local.stage}/*"
}
