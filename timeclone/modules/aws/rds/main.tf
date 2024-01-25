############################################################################################################
## ref : https://github.com/terraform-aws-modules/terraform-aws-rds/tree/master/examples/complete-postgres
############################################################################################################

data "terraform_remote_state" "devops_staging_network" {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "terraform-stag-state-storage"
    dynamodb_table = "stag-terraform-state-table"
    region         = "us-east-1"
    key            = "timeclone/pod-DEVOPS/aws/staging/network/terraform.tfstate"
  }
}

############################################################################################################
# ref : https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/5.3.0
############################################################################################################

module "this" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.3.0"

  identifier = join("-", [var.environment, var.engine, var.name])

  # All available versions: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts
  engine               = var.engine
  engine_version       = var.engine_version
  family               = var.family
  major_engine_version = var.engine_version
  instance_class       = var.instance_class
  allocated_storage    = var.allocated_storage

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  db_name  = join("", [var.name, "db"])
  username = var.jdbc_username
  password = var.jdbc_password
  port     = var.port

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]

  tags = {
    Name        = var.name
    Environment = var.environment
    pod         = var.pod
  }
}


resource "aws_db_subnet_group" "this" {
  name       = join("-", ["private", var.environment, var.engine, var.name])
  subnet_ids = data.terraform_remote_state.devops_staging_network.outputs.stagingVPC.database_subnets

  tags = {
    Name        = join("_", [var.environment, var.engine, var.name])
    Environment = var.environment
    pod         = var.pod
  }
}

resource "aws_security_group" "this" {
  name        = join("_", [var.environment, var.engine, var.name])
  description = "Allow all inbound/outband traffic from own staging private VPC"
  vpc_id      = data.terraform_remote_state.devops_staging_network.outputs.stagingVPC.id

  tags = {
    Name        = join("_", [var.environment, var.engine, var.name])
    Environment = var.environment
    pod         = var.pod
  }
}

resource "aws_security_group_rule" "this1" {
  type              = "ingress"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  cidr_blocks       = [data.terraform_remote_state.devops_staging_network.outputs.stagingVPC.cidr]
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "this2" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}

# Cloudwatch Alarm CPU
resource "aws_cloudwatch_metric_alarm" "cpu" {
  alarm_name                = join("-", [var.environment, var.engine, var.name, "cpu-high"])
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/RDS"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "85"
  unit                      = "Percent"
  alarm_description         = "Alarm if CPU > 85% for 10 minutes"
  insufficient_data_actions = []

  dimensions = {
    DBInstanceIdentifier = module.this.db_instance_id
  }
}


# Cloudwatch Alarm Memory
resource "aws_cloudwatch_metric_alarm" "memory" {
  alarm_name                = join("-", [var.environment, var.engine, var.name, "memory-low"])
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "FreeableMemory"
  namespace                 = "AWS/RDS"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "1048576"
  alarm_description         = "Avaible memory is low under 1MB"
  insufficient_data_actions = []

  dimensions = {
    DBInstanceIdentifier = module.this.db_instance_id
  }
}

