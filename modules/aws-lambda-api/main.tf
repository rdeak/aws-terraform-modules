provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnets" "available" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.project_name}-${var.lambda_function_name}-execution-role"

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
    Name    = "${var.project_name}-${var.lambda_function_name}-execution-role"
    Project = var.project_name
  }
}

resource "aws_iam_role_policy" "lambda_policy_ecr" {
  name = "${var.project_name}-${var.lambda_function_name}-ecr"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "ecr:GetAuthorizationToken"
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
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
  name = "${var.project_name}-${var.lambda_function_name}-logs"
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

resource "aws_iam_role_policy_attachment" "lambda_vpc_access_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}


resource "aws_lambda_function" "lambda_function" {
  function_name = "${var.project_name}-${var.lambda_function_name}"
  role          = aws_iam_role.lambda_exec_role.arn
  package_type  = "Image"
  image_uri     = "${var.docker_repository_url}:${var.lambda_image_tag}"

  vpc_config {
    subnet_ids         = data.aws_subnets.available.ids
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = var.lambda_env
  }

  tags = {
    Name    = "${var.project_name}-${var.lambda_function_name}"
    Project = var.project_name
  }
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_function.function_name}"
  retention_in_days = var.log_retention

  tags = {
    Name    = aws_lambda_function.lambda_function.function_name
    Project = var.project_name
  }
}

resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "${var.project_name}-${var.lambda_function_name}-api"
  protocol_type = "HTTP"

  tags = {
    Name    = "${var.project_name}-${var.lambda_function_name}-api"
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
  route_key = "ANY /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "stage" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = "$default"
  auto_deploy = true

  tags = {
    Stage   = "${var.project_name}-${var.lambda_function_name}-stage"
    Project = var.project_name
  }
}

resource "aws_lambda_permission" "api_gateway_invoke_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}

resource "aws_security_group" "lambda_sg" {
  name   = "${var.project_name}-${var.lambda_function_name}-sg"
  vpc_id = data.aws_vpc.selected.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-${var.lambda_function_name}-sg"
    Project = var.project_name
  }
}