data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnets" "available" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "${var.project_name}-${var.name}"
  subnet_ids = data.aws_subnets.available.ids

  tags = {
    Name    = "${var.project_name}-${var.name}"
    Project = var.project_name
  }
}

resource "aws_security_group" "default" {
  name_prefix = "${var.project_name}-db-sg"
  vpc_id      = data.aws_vpc.selected.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-${var.name}"
    Project = var.project_name
  }
}

resource "aws_rds_cluster" "default" {
  cluster_identifier  = "${var.project_name}-${var.name}"
  engine              = "aurora-postgresql"
  engine_mode         = "provisioned"
  engine_version      = "16.1"
  database_name       = var.name
  master_username     = var.username
  master_password     = var.password
  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.default.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name

  serverlessv2_scaling_configuration {
    min_capacity = var.min_capacity
    max_capacity = var.max_capacity
  }

  tags = {
    Name    = "${var.project_name}-${var.name}"
    Project = var.project_name
  }
}

resource "aws_rds_cluster_instance" "default" {
  cluster_identifier   = aws_rds_cluster.default.id
  identifier           = "${var.project_name}-${var.name}-instance"
  instance_class       = "db.serverless"
  engine               = aws_rds_cluster.default.engine
  engine_version       = aws_rds_cluster.default.engine_version
  db_subnet_group_name = aws_db_subnet_group.default.name
  publicly_accessible  = true

  tags = {
    Name    = "${var.project_name}-${var.name}"
    Project = var.project_name
  }
}
