#setting variables to be used with templatefile
locals {
  RDS_ENDPOINT  = aws_db_instance.rds_instance.endpoint
  DB_NAME       = var.wordpress-db
  DB_USER       = var.db-user
  DB_PASSWORD   = var.db-password
  WORDPRESS_DIR = var.wordpress-dir
}

resource "aws_instance" "wordpress" {
  ami                         = var.amis.us-east-1
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.deployer.key_name
  subnet_id                   = module.vpc.public_subnets.0
  security_groups             = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true

  user_data = base64encode(templatefile("script.sh", {
    #variables to be used within tempalatefile
    RDS_ENDPOINT  = local.RDS_ENDPOINT
    DB_NAME       = local.DB_NAME
    DB_USER       = local.DB_USER
    DB_PASSWORD   = local.DB_PASSWORD
    WORDPRESS_DIR = local.WORDPRESS_DIR
  }))

}