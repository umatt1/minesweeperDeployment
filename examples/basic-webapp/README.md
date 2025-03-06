# Basic Web Application Example

This example demonstrates how to use the Web Application module to deploy a basic web application with a frontend, backend API, and database on AWS.

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