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
| [aws_lightsail_database.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_database) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | The name of the master database. | `string` | n/a | yes |
| <a name="input_database_pass"></a> [database\_pass](#input\_database\_pass) | The master password for your new database. | `string` | n/a | yes |
| <a name="input_database_user"></a> [database\_user](#input\_database\_user) | The master user name for your new database. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_base"></a> [database\_base](#output\_database\_base) | The master database name from the database. |
| <a name="output_database_host"></a> [database\_host](#output\_database\_host) | The master endpoint fqdn for the database. |
| <a name="output_database_pass"></a> [database\_pass](#output\_database\_pass) | The master password for the database. |
| <a name="output_database_port"></a> [database\_port](#output\_database\_port) | The master endpoint network port for the database. |
| <a name="output_database_user"></a> [database\_user](#output\_database\_user) | The master user for the database. |
