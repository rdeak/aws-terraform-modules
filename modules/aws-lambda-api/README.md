## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_apigatewayv2_api.api_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api) | resource |
| [aws_apigatewayv2_integration.lambda_integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration) | resource |
| [aws_apigatewayv2_route.default_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_route) | resource |
| [aws_apigatewayv2_stage.stage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_stage) | resource |
| [aws_iam_role.lambda_exec_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_policy_ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.lambda_policy_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_basic_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.lambda_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.api_gateway_invoke_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to deploy to | `string` | `"us-east-1"` | no |
| <a name="input_docker_repository_arn"></a> [docker\_repository\_arn](#input\_docker\_repository\_arn) | ECR ARN | `string` | n/a | yes |
| <a name="input_docker_repository_url"></a> [docker\_repository\_url](#input\_docker\_repository\_url) | ECR url | `string` | n/a | yes |
| <a name="input_lambda_function_name"></a> [lambda\_function\_name](#input\_lambda\_function\_name) | The name of the Lambda function | `string` | n/a | yes |
| <a name="input_lambda_image_tag"></a> [lambda\_image\_tag](#input\_lambda\_image\_tag) | The tag of the Lambda Docker image | `string` | `"latest"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name | `string` | `"my-project"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_endpoint"></a> [api\_endpoint](#output\_api\_endpoint) | Invoke URL of the API Gateway |
| <a name="output_lambda_exec_role_arn"></a> [lambda\_exec\_role\_arn](#output\_lambda\_exec\_role\_arn) | ARN of the lambda exec role |
| <a name="output_lambda_exec_role_id"></a> [lambda\_exec\_role\_id](#output\_lambda\_exec\_role\_id) | Id of the lambda exec role |
| <a name="output_lambda_exec_role_name"></a> [lambda\_exec\_role\_name](#output\_lambda\_exec\_role\_name) | Name of the lambda exec role |
| <a name="output_lambda_function_arn"></a> [lambda\_function\_arn](#output\_lambda\_function\_arn) | ARN of the lambda function |
| <a name="output_lambda_function_name"></a> [lambda\_function\_name](#output\_lambda\_function\_name) | ARN of the lambda function |
