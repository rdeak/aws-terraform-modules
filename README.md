# AWS Terraform modules

## Modules

| Name              | Description                                                  |
|-------------------|--------------------------------------------------------------|
| aws-s3-backend    | Provisions AWS resources needed for handling terraform state |
| aws-app-bootstrap | Provisions AWS resources for an app and enables Github OIDC  |

## Dev snippets

```bash
terraform-docs markdown table . > README.md
```

```bash
terraform init -backend-config=backend.hcl
```

## License

This project is licensed under the terms of the MIT license.