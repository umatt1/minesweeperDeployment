# Terraform AWS Guestbook Module

This Terraform module deploys a complete guestbook application infrastructure on AWS using ECS (Elastic Container Service). The module sets up a fully functional environment including VPC, ECS cluster, RDS database, and all necessary networking components.

## Features

- VPC with public and private subnets
- ECS cluster with Fargate
- RDS database instance
- Application Load Balancer
- Auto-scaling capabilities
- Secure network configuration
- Optional Route 53 DNS configuration

## Usage

### Basic Usage (without DNS)

```hcl
module "guestbook" {
  source = "github.com/your-username/minesweeperDeployment//terraform-aws-guestbook"

  environment = "prod"
  region     = "us-east-2"

  # Database configuration
  db_name     = "guestbook"
  db_username = "admin"
  db_password = "your-secure-password"
  
  # Optional configurations
  client_image = "brietsparks/guestbook-client:latest"
  server_image = "brietsparks/guestbook-server:latest"
}
```

### Usage with DNS Configuration

```hcl
module "guestbook" {
  source = "github.com/your-username/minesweeperDeployment//terraform-aws-guestbook"

  environment = "prod"
  region     = "us-east-2"

  # Database configuration
  db_name     = "guestbook"
  db_username = "admin"
  db_password = "your-secure-password"
  
  # DNS Configuration
  domain_name = "example.com"
  create_route53_zone = true  # Set to false if using existing zone
  # route53_zone_id = "Z1234567890"  # Uncomment if using existing zone
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.7.4 |
| aws | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| vpc | terraform-aws-modules/vpc/aws | 5.19.0 |
| ecs | ./modules/ecs | n/a |
| db | ./modules/db | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | The environment (e.g., prod, dev, staging) | `string` | n/a | yes |
| region | AWS region to deploy resources | `string` | `"us-east-2"` | no |
| availability_zones | List of AWS availability zones | `list(string)` | `["us-east-2a", "us-east-2b"]` | no |
| db_name | Name of the database | `string` | n/a | yes |
| db_username | Database username | `string` | n/a | yes |
| db_password | Database password | `string` | n/a | yes |
| client_image | Docker image for the client application | `string` | `"brietsparks/guestbook-client:latest"` | no |
| server_image | Docker image for the server application | `string` | `"brietsparks/guestbook-server:latest"` | no |
| client_container_port | Port for the client container | `number` | `80` | no |
| server_container_port | Port for the server container | `number` | `80` | no |
| domain_name | Domain name for the application | `string` | `null` | no |
| create_route53_zone | Whether to create a new Route 53 hosted zone | `bool` | `false` | no |
| route53_zone_id | ID of an existing Route 53 hosted zone | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| alb_dns_host | The DNS name of the application load balancer |
| vpc_id | The ID of the VPC |
| private_subnets | List of private subnet IDs |
| public_subnets | List of public subnet IDs |
| db_url | The connection URL for the database (sensitive) |

## Examples

The module includes several example configurations in the [examples](./examples) directory:

- [complete](./examples/complete) - Basic example without DNS configuration
- [with-dns](./examples/with-dns) - Example with Route 53 DNS configuration
- [without-dns](./examples/without-dns) - Example using ALB DNS name only

## DNS Configuration

The module supports three DNS configuration patterns:

1. No DNS Configuration (default)
   - Access application through ALB DNS name
   - No Route 53 resources created

2. New Route 53 Zone
   - Set `domain_name` and `create_route53_zone = true`
   - Creates new hosted zone and records

3. Existing Route 53 Zone
   - Set `domain_name` and provide `route53_zone_id`
   - Creates records in existing zone

## Security

This module implements several security best practices:
- Private subnets for ECS tasks and RDS
- Security groups with minimal required access
- HTTPS/TLS for load balancer
- No direct database access from public internet

## License

Apache 2 Licensed. See [LICENSE](./LICENSE) for full details. 