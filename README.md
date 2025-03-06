# Terraform AWS Web Application Deployment Module

This Terraform module deploys a containerized web application with a frontend, backend API, and database on AWS. It sets up the complete infrastructure including VPC, ECS, RDS, IAM roles, and security groups.

## Features

- Complete VPC setup with public and private subnets
- ECS Fargate for containerized deployment
- Database setup
- Load balancing and auto-scaling
- Secure network configuration
- Multi-environment support (dev, test, prod)

## Usage

```hcl
module "webapp" {
  source = "github.com/yourusername/terraform-aws-webapp"
  
  application_name = "myapp"
  environment      = "prod"
  region           = "us-east-2"
  
  # Container images
  server_image = "123456789012.dkr.ecr.us-east-2.amazonaws.com/myapp-server:latest"
  client_image = "123456789012.dkr.ecr.us-east-2.amazonaws.com/myapp-client:latest"
  
  # Database configuration
  db_name     = "myappdb"
  db_username = "dbuser"
  db_password = "dbpassword"
  
  # Optional customizations
  vpc_cidr = "10.0.0.0/16"
  
  tags = {
    Project     = "My Application"
    ManagedBy   = "Terraform"
    Environment = "prod"
  }
}
```

## Examples

Complete examples can be found in the [examples](./examples/) directory:

- [Basic Web Application](./examples/basic-webapp/)
- [Development Environment](./examples/dev-environment/)
- [Production Environment](./examples/prod-environment/)

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| application_name | The name of the application | `string` | `"webapp"` | no |
| environment | The deployment environment (e.g., dev, test, prod) | `string` | n/a | yes |
| region | AWS region to deploy into | `string` | `"us-east-2"` | no |
| availability_zones | List of AWS availability zones in the region | `list(string)` | `["us-east-2a", "us-east-2b"]` | no |
| vpc_cidr | CIDR block for the VPC | `string` | `"10.0.0.0/16"` | no |
| server_image | Docker image for the server application | `string` | n/a | yes |
| client_image | Docker image for the client application | `string` | n/a | yes |
| server_container_port | Port that the server application listens on | `number` | `80` | no |
| client_container_port | Port that the client application listens on | `number` | `80` | no |
| db_name | Name of the database | `string` | `"appdb"` | no |
| db_username | Username for database access | `string` | n/a | yes |
| db_password | Password for database access | `string` | n/a | yes |
| tags | A map of tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| client_url | The URL of the client application |
| server_url | The URL of the server API |
| db_endpoint | The endpoint of the database |

## License

MIT

## Authors

- Your Name

This is the terraform code for my deployment of the minesweeple application. 
It is still in progress and I am actively learning in this repository.
Currently, the backend is deploying and running. Next steps are connecting the front end


![aws-arch-diagram](https://github.com/user-attachments/assets/0ea6865f-5711-40a5-8510-06fac849642c)


Important todo:
Update the container image!
Hopefully this fixes the application context path! Perhaps health check failing due to /api/v1