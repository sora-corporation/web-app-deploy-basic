locals {
  engine_version = "16.6"
  instance_class = "db.t4g.medium"
}

module "db" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "9.13.0"

  name                        = "db-${var.project}-prod"
  engine                      = "aurora-postgresql"
  master_username             = "root"
  manage_master_user_password = true
  # !!! WARNING !!!
  # https://github.com/terraform-aws-modules/terraform-aws-rds/issues/538
  # のバグが再発しているのか、ローテーションが自動的にONになってしまうため、手動でオフにする必要がある
  manage_master_user_password_rotation = false
  skip_final_snapshot                  = true
  performance_insights_enabled         = true
  engine_version                       = local.engine_version
  instance_class                       = local.instance_class
  instances = {
    one = {}
  }
  autoscaling_enabled      = true
  autoscaling_min_capacity = 0
  autoscaling_max_capacity = 1

  vpc_id                 = module.vpc.vpc_id
  create_db_subnet_group = true
  subnets                = module.vpc.private_subnets

  security_group_rules = {
    vpc_ingress = {
      cidr_blocks = concat(
        module.vpc.private_subnets_cidr_blocks,
      )
    }
  }

  storage_encrypted   = true
  apply_immediately   = true
  monitoring_interval = 10

  # NOTE: メジャーバージョンを上げる場合は一度trueにしてapplyしてからアップグレードする
  # allow_major_version_upgrade = true

  create_db_cluster_parameter_group      = true
  db_cluster_parameter_group_name        = "default-16"
  db_cluster_parameter_group_family      = "aurora-postgresql16"
  db_cluster_parameter_group_description = "Default parameter group for Aurora PostgreSQL 16"
  db_cluster_parameter_group_parameters = [
    {
      name         = "timezone"
      value        = "Asia/Tokyo"
      apply_method = "immediate"
    },
    {
      name         = "log_statement"
      value        = "mod"
      apply_method = "immediate"
    },
    {
      name         = "log_min_duration_statement"
      value        = 1000
      apply_method = "immediate"
    },
  ]

  create_db_parameter_group      = true
  db_parameter_group_name        = "default-16"
  db_parameter_group_family      = "aurora-postgresql16"
  db_parameter_group_description = "Default parameter group for Aurora PostgreSQL 16"
  db_parameter_group_parameters  = []

  enabled_cloudwatch_logs_exports = ["postgresql"]

  database_name = "sample_app"
}
