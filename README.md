# AWS ECS Guestbook Infrastructure

This repository contains Terraform configurations for deploying a guestbook application on AWS ECS. It includes both a reusable Terraform module (`terraform-aws-guestbook`) and example infrastructure deployments.

## Repository Structure

- `terraform-aws-guestbook/` - The main Terraform module for deploying the guestbook application
  - `modules/` - Sub-modules for ECS, RDS, and other components
  - `examples/` - Example configurations showing different deployment patterns
    - `complete/` - Basic example without DNS configuration
    - `with-dns/` - Example with Route 53 DNS configuration
    - `without-dns/` - Example using ALB DNS name only
- `infrastructure/` - Reference implementation using the module
  - `environments/` - Environment-specific configurations (prod, test)
  - `modules/` - Additional infrastructure modules
  - `test/` - Infrastructure tests

## Getting Started

1. Choose an example configuration from `terraform-aws-guestbook/examples/`:
   - Use `complete/` for a basic setup
   - Use `with-dns/` if you want to configure DNS with Route 53
   - Use `without-dns/` if you want to use the ALB's DNS name

2. Initialize and apply the configuration:
```bash
cd terraform-aws-guestbook/examples/[chosen-example]
terraform init
terraform plan
terraform apply
```

3. Access your application using the URL from the `application_url` output

## Module Documentation

For detailed module documentation, see [terraform-aws-guestbook/README.md](terraform-aws-guestbook/README.md)

## Development

To work on this repository:

1. Install prerequisites:
   - Terraform >= 1.7.4
   - AWS CLI configured with appropriate credentials

2. Run tests:
```bash
make test
```

3. Deploy to development:
```bash
make dev
```

## License

Apache 2.0 - See [LICENSE](terraform-aws-guestbook/LICENSE) for details