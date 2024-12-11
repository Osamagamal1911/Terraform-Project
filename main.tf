provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./vpc"
  region = var.region
}

module "security_group" {
  source   = "./security_group"
  vpc_id   = module.vpc.vpc_id
  vpc_cidr = module.vpc.vpc_cidr
  prefix   = "myapp"  # Change this to your desired prefix
}

module "auto_scaling" {
  source             = "./auto_scaling"
  private_subnet_ids = module.vpc.private_subnet_ids  # Reference the private subnet IDs from the VPC module
  private_sg_id     = module.security_group.private_sg_id
  prefix             = "myapp"  # Change this to your desired prefix
  key                    = module.key.myapp-key
}

module "bastion" {
  source                 = "./bastion"
  prefix                 = "myapp" # Change as desired
  region                 = var.region
  instance_type          = "t3.micro" # Customize as needed
  public_subnet_ids       = module.vpc.public_subnet_ids # Reference from VPC module
  public_security_group_id = module.security_group.public_sg_id # Reference from Security Group module
  volume_size            = 30 # Adjust as needed
  key                    = module.key.myapp-key
}

module "load_balancer" {
  source            = "./load_balancer"  # Adjust the path as needed
  prefix            = "myapp"  # Change this to your desired prefix
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  loadbalancer_sg_id     = module.security_group.loadbalancer_sg_id
  as_group1_id    = module.auto_scaling.asg1_id
  as_group2_id    = module.auto_scaling.asg2_id


}

module "rds_sql_server" {
  source                = "./rds" # Path to the RDS module directory
  rds_security_group_ids = module.security_group.rds_sg_id
  private_subnet_ids    = module.vpc.private_subnet_ids
}

# main.tf
module "key" {
  source = "./key"
}


output "public_sg_id" {
  value = module.security_group.public_sg_id
}

output "private_sg_id" {
  value = module.security_group.private_sg_id
}

output "asg1_id" {
  value = module.auto_scaling.asg1_id
}

output "asg2_id" {
  value = module.auto_scaling.asg2_id
}
