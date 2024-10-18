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
| [aws_ecr_repository.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_iam_role.github_actions_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.github_actions_policy_ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS account ID where resources will be created. | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to create resources in. | `string` | n/a | yes |
| <a name="input_branch_name"></a> [branch\_name](#input\_branch\_name) | The branch name to allow for OIDC authentication. | `string` | `"*"` | no |
| <a name="input_github_repository"></a> [github\_repository](#input\_github\_repository) | The GitHub repository in the format 'owner/repo'. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_docker_repository_arn"></a> [docker\_repository\_arn](#output\_docker\_repository\_arn) | n/a |
| <a name="output_docker_repository_name"></a> [docker\_repository\_name](#output\_docker\_repository\_name) | n/a |
| <a name="output_docker_repository_url"></a> [docker\_repository\_url](#output\_docker\_repository\_url) | n/a |
| <a name="output_github_role_arn"></a> [github\_role\_arn](#output\_github\_role\_arn) | n/a |
| <a name="output_github_role_id"></a> [github\_role\_id](#output\_github\_role\_id) | n/a |
| <a name="output_github_role_name"></a> [github\_role\_name](#output\_github\_role\_name) | n/a |
