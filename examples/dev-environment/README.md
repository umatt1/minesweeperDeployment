# Development Environment Example

This example demonstrates how to use the Web Application module to deploy a development environment with a frontend, backend API, and database on AWS. It includes development-specific configurations like smaller network settings and cost-saving options.

## Usage

To run this example, you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources anymore.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | >= 4.0.0 |

## Providers

No providers.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| client_url | URL of the client application |
| server_url | URL of the server API |
| db_endpoint | The endpoint of the database | 