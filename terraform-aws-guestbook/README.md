# Terraform AWS Guestbook Module

This Terraform module deploys a complete guestbook application infrastructure on AWS using ECS (Elastic Container Service). The module sets up a fully functional environment including VPC, ECS cluster, RDS database, and all necessary networking components.

## Features

- VPC with public and private subnets
- ECS cluster with Fargate
- RDS database instance
- Application Load Balancer
- Auto-scaling capabilities
- Secure network configuration
- DynamoDB table support

## Usage

```hcl
module "guestbook" {
  source  = "your-username/guestbook/aws"
  version = "1.0.0"

  environment          = "prod"
  region              = "us-east-2"
  db_name             = "guestbook"
  db_username         = "admin"
  db_password         = "your-secure-password"
  
  # Optional configurations
  client_image        = "your-client-image:latest"
  server_image        = "your-server-image:latest"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.7.4 |
| aws | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| vpc | terraform-aws-modules/vpc/aws | n/a |
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
| client_image | Docker image for the client application | `string` | `"brietsparks/guestbook-client"` | no |
| server_image | Docker image for the server application | `string` | `"brietsparks/guestbook-server"` | no |
| client_container_port | Port for the client container | `number` | `80` | no |
| server_container_port | Port for the server container | `number` | `80` | no |

## Outputs

| Name | Description |
|------|-------------|
| alb_dns_host | The DNS name of the application load balancer |
| db_url | The connection URL for the database |

## Examples

See the [examples](./examples) directory for working examples to get started with.

## License

Apache 2 Licensed. See LICENSE for full details. 