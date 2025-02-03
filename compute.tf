#setting variables to be used with templatefile
locals {
  RDS_ENDPOINT  = aws_db_instance.rds_instance.endpoint
  DB_NAME       = var.wordpress-db
  DB_USER       = var.db-user
  DB_PASSWORD   = var.db-password
  WORDPRESS_DIR = var.wordpress-dir
}

# Create the Launch Template
resource "aws_launch_template" "wordpress_launch_template" {
  name_prefix   = "wordpress-launch-template"
  image_id      = var.amis.us-east-1
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  security_group_names = [aws_security_group.allow_ssh.name]

  user_data = base64encode(templatefile("script.sh", {
    # Variables to be used within templatefile
    RDS_ENDPOINT  = local.RDS_ENDPOINT
    DB_NAME       = local.DB_NAME
    DB_USER       = local.DB_USER
    DB_PASSWORD   = local.DB_PASSWORD
    WORDPRESS_DIR = local.WORDPRESS_DIR
  }))

  lifecycle {
    create_before_destroy = true
  }
}

# Create the Auto Scaling Group (ASG)
resource "aws_autoscaling_group" "wordpress_asg" {
  desired_capacity     = 2  # Adjust the desired instances (scale size)
  min_size             = 1  # Minimum number of instances
  max_size             = 3  # Maximum number of instances
  vpc_zone_identifier  = module.vpc.public_subnets
  launch_template {
    id      = aws_launch_template.wordpress_launch_template.id
    version = "$Latest"
  }

  health_check_type          = "EC2"
  health_check_grace_period = 300
  force_delete               = true
  wait_for_capacity_timeout   = "0"
  availability_zones         = module.vpc.availability_zones  # Automatically pull AZs
}

# Create an Auto Scaling Policy (Scale Out Policy)
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out-policy"
  scaling_adjustment     = 1      # Number of instances to add
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300    # Cooldown period in seconds
  autoscaling_group_name  = aws_autoscaling_group.wordpress_asg.name
}

# Create an Auto Scaling Policy (Scale In Policy)
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in-policy"
  scaling_adjustment     = -1     # Number of instances to remove
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300    # Cooldown period in seconds
  autoscaling_group_name  = aws_autoscaling_group.wordpress_asg.name
}
