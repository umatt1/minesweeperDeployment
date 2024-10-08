## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.7.4 |
| aws | >= 2.0 |

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| availability\_zones | array of aws availability zones of the provided region | `list(string)` | <pre>[<br>  "us-east-2a",<br>  "us-east-2b"<br>]</pre> | no |
| client\_container\_port | the port that the client serves from | `string` | `80` | no |
| client\_image | image name of the client app | `string` | `"brietsparks/guestbook-client"` | no |
| dynamo\_read\_capacity | the dynamo read throughput | `string` | `15` | no |
| dynamo\_write\_capacity | the dynamo write throughput | `string` | `15` | no |
| region | an aws region | `string` | `"us-east-2"` | no |
| server\_container\_port | the port that the server serves from | `string` | `80` | no |
| server\_image | image name of the server app | `string` | `"brietsparks/guestbook-server"` | no |

## Outputs

| Name | Description |
|------|-------------|
| alb\_dns\_host | the load balancer's DNS host address |

