# Guestbook without DNS Configuration

This example demonstrates how to deploy the guestbook application without a custom domain name. The application will be accessible through the Application Load Balancer's DNS name.

## Configuration

The example creates:
- All infrastructure (VPC, ECS, RDS, etc.)
- No DNS configuration

## Usage

1. Run `terraform init` and `terraform apply`
2. Access the application using the ALB DNS name from the `application_url` output

## Outputs

- `application_url`: The HTTP URL of your application using the ALB DNS name
- `vpc_id`: The ID of the created VPC 