module "rds" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "tf-db-1"

  engine            = "MariaDB"
  engine_version    = "11.4.4"
  instance_class    = "db.t4g.micro"
  allocated_storage = 20

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = "3306"

  iam_database_authentication_enabled = false

  publicly_accessible = false
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  create_db_subnet_group = true
  subnet_ids             = module.vpc.private_subnets


  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # DB parameter group
  family = "mariadb11.4"

  # DB option group
  major_engine_version = "11.4"

}