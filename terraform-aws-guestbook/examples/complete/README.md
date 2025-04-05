# Complete Guestbook Application Example

This example demonstrates a complete deployment of the Guestbook application using the AWS Guestbook Terraform module.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.7.4 |
| aws | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.0 |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| application_url | URL of the deployed application |
| vpc_id | ID of the created VPC |

## Notes

- The database password is hardcoded in this example for demonstration purposes. In a production environment, you should use AWS Secrets Manager or similar service to manage sensitive information.
- The example uses default container images. In production, you should use your own container images with specific versions.
- The example deploys resources in us-east-2. Adjust the region according to your needs. 