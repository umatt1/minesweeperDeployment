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
  environment                  = var.container_environment
  port_mappings                = var.container_port_mappings
}

module "test_policy" {
  source  = "cloudposse/iam-policy/aws"
  version = "0.4.0"

  name       = "policy"
  attributes = ["test"]

  iam_policy_enabled = true
  description        = "Test policy"

  iam_policy_statements = [
    {
      sid        = "DummyStatement"
      effect     = "Allow"
      actions    = ["none:null"]
      resources  = ["*"]
      conditions = []
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
  task_policy_arns                   = [module.test_policy.policy_arn]
  task_exec_policy_arns_map          = { test = module.test_policy.policy_arn }

  context = module.this.context
}

module "rds_instance" {
    source = "cloudposse/rds/aws"
    # Cloud Posse recommends pinning every module to a specific version
    # version = "x.x.x"
    namespace                   = "eg"
    stage                       = "prod"
    name                        = "app"
    dns_zone_id                 = "Z89FN1IW975KPE"
    host_name                   = "db"
    security_group_ids          = ["sg-xxxxxxxx"]
    ca_cert_identifier          = "rds-ca-2019"
    allowed_cidr_blocks         = ["XXX.XXX.XXX.XXX/32"]
    database_name               = "wordpress"
    database_user               = "admin"
    database_password           = "xxxxxxxxxxxx"
    database_port               = 3306
    multi_az                    = true
    storage_type                = "gp2"
    allocated_storage           = 100
    storage_encrypted           = true
    engine                      = "mysql"
    engine_version              = "5.7.17"
    major_engine_version        = "5.7"
    instance_class              = "db.t2.medium"
    db_parameter_group          = "mysql5.7"
    option_group_name           = "mysql-options"
    publicly_accessible         = false
    subnet_ids                  = ["sb-xxxxxxxxx", "sb-xxxxxxxxx"]
    vpc_id                      = "vpc-xxxxxxxx"
    snapshot_identifier         = "rds:production-2015-06-26-06-05"
    auto_minor_version_upgrade  = true
    allow_major_version_upgrade = false
    apply_immediately           = false
    maintenance_window          = "Mon:03:00-Mon:04:00"
    skip_final_snapshot         = false
    copy_tags_to_snapshot       = true
    backup_retention_period     = 7
    backup_window               = "22:00-03:00"

    db_parameter = [
      { name  = "myisam_sort_buffer_size"   value = "1048576" },
      { name  = "sort_buffer_size"          value = "2097152" }
    ]

    db_options = [
      { option_name = "MARIADB_AUDIT_PLUGIN"
          option_settings = [
            { name = "SERVER_AUDIT_EVENTS"           value = "CONNECT" },
            { name = "SERVER_AUDIT_FILE_ROTATIONS"   value = "37" }
          ]
      }
    ]
}