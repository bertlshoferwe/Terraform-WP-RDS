module "vpc" {
  //where the terraform module is loacted    
  source = "terraform-aws-modules/vpc/aws"
  //VPC creation information
  name = var.vpc-name
  cidr = var.VpcCIDR
  //create AZ's, private, and public subnets
  azs             = [var.zones.zone1, var.zones.zone2]
  private_subnets = [var.privSub.sub1, var.privSub.sub2]
  public_subnets  = [var.pubSub.sub1, var.pubSub.sub2]
  //enable nat gatway
  enable_nat_gateway = true
  single_nat_gateway = false
  // Skip creation of EIPs for the NAT Gateways
  reuse_nat_ips = true
  // IPs specified here as input to the module
  external_nat_ip_ids = aws_eip.nat.*.id
  //enable dns suppport
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_eip" "nat" {
  count = 2

}