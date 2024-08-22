data "aws_rds_engine_version" "rds_enginer" {
  engine = "mysql"
  version = "8.0.35"
}

data "aws_availability_zones" "aws_availability_zones" {
  state = "available"
}

resource "aws_db_subnet_group" "tf_subnet_groups" {
  name = "${var.project_name}-tf-subnet-groups"
  subnet_ids = [var.private_subnet_1a_data, var.private_subnet_1b_data]
  tags = {
    Name = "${var.project_name}-subnet-groups"
  }
}

resource "aws_db_instance" "tf_rds_cluster" {
  allocated_storage           = 30
  auto_minor_version_upgrade  = false                         # Custom for Oracle does not support minor version upgrades
  backup_retention_period     = 7
  db_subnet_group_name        = aws_db_subnet_group.tf_subnet_groups.name
  engine                      = data.aws_rds_engine_version.rds_enginer.engine
  engine_version              = data.aws_rds_engine_version.rds_enginer.version
  identifier                  = "db-master"
  instance_class              = "db.m5d.large"
  multi_az                    = false # Custom for mysql does not support multi-az
  password                    = var.password
  username                    = "lmduccloud"
  storage_encrypted           = true
  skip_final_snapshot  = true

  tags = {
    Name = "${var.project_name}-master-rds"
  }

  timeouts {
    create = "3h"
    delete = "3h"
    update = "3h"
  }
}




resource "aws_db_instance" "test-replica" {
  replicate_source_db         = aws_db_instance.tf_rds_cluster.identifier
  auto_minor_version_upgrade  = false
  backup_retention_period     = 7
  identifier                  = "db-replica"
  instance_class              = "db.m5d.large"
  multi_az                    = false # Custom for Mysql does not support multi-az
  skip_final_snapshot         = true
  storage_encrypted           = true
  vpc_security_group_ids = [
    var.tf_sg_rds
  ]

  tags = {
    Name = "${var.project_name}-replicaset"
  }

  timeouts {
    create = "3h"
    delete = "3h"
    update = "3h"
  }
}

