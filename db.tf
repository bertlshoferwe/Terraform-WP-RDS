#rds subnet
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [module.vpc.private_subnets.0, module.vpc.private_subnets.1]
}

resource "aws_db_instance" "rds_instance" {
  engine                 = "mysql"
  engine_version         = "8.0"
  skip_final_snapshot    = true
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = var.wordpress-db
  username               = var.db-user
  password               = var.db-password
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  multi_az               = true
  availability_zone      = null 
}