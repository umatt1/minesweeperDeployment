// ECS cluster tied to RDS with ALB

provider "aws" {
  region = var.region
}

locals {
  enabled = module.this.enabled
}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "2.0.0"

  ipv4_primary_cidr_block = var.vpc_cidr_block

  context = module.this.context
}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "2.1.0"

  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = [module.vpc.igw_id]
  ipv4_cidr_block      = [module.vpc.vpc_cidr_block]
  nat_gateway_enabled  = false
  nat_instance_enabled = false

  context = module.this.context
}

resource "aws_ecs_cluster" "default" {
  #bridgecrew:skip=BC_AWS_LOGGING_11: not required for testing
  count = local.enabled ? 1 : 0
  name  = module.this.id
  tags  = module.this.tags
}

module "container_definition" {
  count = local.enabled ? 1 : 0

  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.58.2"

  container_name               = var.container_name
  container_image              = var.container_image
  container_memory             = var.container_memory
  container_memory_reservation = var.container_memory_reservation
  container_cpu                = var.container_cpu
  essential                    = var.container_essential
  readonly_root_filesystem     = var.container_readonly_root_filesystem

  map_environment = {
    "DB_PASSWORD" = var.database_password
    "DB_URL"      = "jdbc:postgresql://${module.rds_instance.instance_endpoint}/sweepledb"
    "DB_USERNAME" = var.database_user
  }

  port_mappings = var.container_port_mappings

  log_configuration = {
    log_driver = "awslogs"
    options = {
      "awslogs-group"         = "/ecs/${var.container_name}"
      "awslogs-region"        = var.region
      "awslogs-stream-prefix" = var.container_name
    }
  }
}


module "ecs_policy" {
  source  = "cloudposse/iam-policy/aws"
  version = "0.4.0"

  name       = "ecs_policy"
  attributes = ["cluster"]

  iam_policy_enabled = true
  description        = "Policy for the ECS instances"

  iam_policy_statements = [
    {
      sid    = "SecretsManagerDbCredentialsAccess"
      effect = "Allow"
      actions = [
        "secretsmanager:GetSecretValue",
        "secretsmanager:PutResourcePolicy",
        "secretsmanager:PutSecretValue",
        "secretsmanager:DeleteSecret",
        "secretsmanager:DescribeSecret",
        "secretsmanager:TagResource"
      ]
      resources = ["arn:aws:secretsmanager:*:*:secret:rds-db-credentials/*"]
    },
    {
      sid    = "RDSDataServiceAccess"
      effect = "Allow"
      actions = [
        "dbqms:CreateFavoriteQuery",
        "dbqms:DescribeFavoriteQueries",
        "dbqms:UpdateFavoriteQuery",
        "dbqms:DeleteFavoriteQueries",
        "dbqms:GetQueryString",
        "dbqms:CreateQueryHistory",
        "dbqms:DescribeQueryHistory",
        "dbqms:UpdateQueryHistory",
        "dbqms:DeleteQueryHistory",
        "rds-data:ExecuteSql",
        "rds-data:ExecuteStatement",
        "rds-data:BatchExecuteStatement",
        "rds-data:BeginTransaction",
        "rds-data:CommitTransaction",
        "rds-data:RollbackTransaction",
        "secretsmanager:CreateSecret",
        "secretsmanager:ListSecrets",
        "secretsmanager:GetRandomPassword",
        "tag:GetResources"
      ]
      resources = ["*"]
    }
  ]
  context = module.this.context
}


module "ecs_alb_service_task" {
  source                             = "cloudposse/ecs-alb-service-task/aws"
  alb_security_group                 = module.vpc.vpc_default_security_group_id
  container_definition_json          = one(module.container_definition.*.json_map_encoded_list)
  ecs_cluster_arn                    = one(aws_ecs_cluster.default.*.id)
  launch_type                        = var.ecs_launch_type
  vpc_id                             = module.vpc.vpc_id
  security_group_ids                 = [module.vpc.vpc_default_security_group_id]
  subnet_ids                         = module.subnets.public_subnet_ids
  ignore_changes_task_definition     = var.ignore_changes_task_definition
  network_mode                       = var.network_mode
  assign_public_ip                   = var.assign_public_ip
  propagate_tags                     = var.propagate_tags
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_controller_type         = var.deployment_controller_type
  desired_count                      = var.desired_count
  task_memory                        = var.task_memory
  task_cpu                           = var.task_cpu
  ecs_service_enabled                = var.ecs_service_enabled
  force_new_deployment               = var.force_new_deployment
  redeploy_on_apply                  = var.redeploy_on_apply
  task_policy_arns                   = [module.ecs_policy.policy_arn]
  task_exec_policy_arns_map          = { test = module.ecs_policy.policy_arn }

  context = module.this.context
}

module "rds_instance" {
  source = "cloudposse/rds/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version = "x.x.x"
  namespace = "sl"
  stage     = var.stage
  name      = var.name
  # dns_zone_id          = var.dns_zone_id // tbd
  host_name            = var.host_name // tbd
  security_group_ids   = [module.vpc.vpc_default_security_group_id]
  ca_cert_identifier   = var.ca_cert_identifier // tbd
  allowed_cidr_blocks  = [var.vpc_cidr_block]
  database_name        = var.database_name
  database_user        = var.database_user
  database_password    = var.database_password
  database_port        = var.database_port
  multi_az             = var.multi_az
  storage_type         = var.storage_type
  allocated_storage    = var.allocated_storage
  storage_encrypted    = var.storage_encrypted
  engine               = var.engine
  engine_version       = var.engine_version
  major_engine_version = var.major_engine_version
  instance_class       = var.instance_class
  db_parameter_group   = var.db_parameter_group
  option_group_name    = var.option_group_name
  publicly_accessible  = var.publicly_accessible
  subnet_ids           = module.subnets.public_subnet_ids
  vpc_id               = module.vpc.vpc_id
  # snapshot_identifier         = "rds:production-2015-06-26-06-05"
  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = false
  apply_immediately           = false
  maintenance_window          = "Mon:03:00-Mon:04:00"
  skip_final_snapshot         = true
  copy_tags_to_snapshot       = true
  backup_retention_period     = 35
  backup_window               = "22:00-03:00"

}