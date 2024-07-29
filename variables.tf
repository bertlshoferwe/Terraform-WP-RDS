variable "aws-region" {
  default = "us-east-1"
}
variable "amis" {
  type = map(string)
  default = {
    us-east-1 = "ami-04b70fa74e45c3917"
    us-east-2 = "ami-04b70fa74e45c3917"
  }
}
variable "vpc-name" {
  default = "terraform-VPC"
}
variable "zones" {
  type = map(string)
  default = {
    zone1 = "us-east-1a"
    zone2 = "us-east-1b"
  }
}
variable "VpcCIDR" {
  default = "10.0.0.0/16"
}

variable "pubSub" {
  type = map(string)
  default = {
    sub1 = "10.0.1.0/24"
    sub2 = "10.0.2.0/24"
  }
}
variable "privSub" {
  type = map(string)
  default = {
    sub1 = "10.0.3.0/24"
    sub2 = "10.0.4.0/24"
  }
}

variable "wordpress-db" {
  default = "wordpress_db"

}

variable "db-user" {
  default = "weston"

}

variable "db-password" {
  default = "weston1324"

}

variable "wordpress-dir" {
  default = "/var/www/html"

}