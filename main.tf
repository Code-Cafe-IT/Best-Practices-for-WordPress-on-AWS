module "vpc" {
  source                 = "./module/VPC"
  vpc_cidr               = var.vpc_cidr
  project_name           = var.project_name
  public_subnet_1a       = var.public_subnet_1a
  public_subnet_1b       = var.public_subnet_1b
  private_subnet_1a_app  = var.private_subnet_1a_app
  private_subnet_1b_app  = var.private_subnet_1b_app
  private_subnet_1a_data = var.private_subnet_1a_data
  private_subnet_1b_data = var.private_subnet_1b_data
}

module "s3" {
  source       = "./module/S3"
  project_name = var.project_name
}

module "rds" {
  source                 = "./module/RDS"
  project_name           = var.project_name
  private_subnet_1a_data = module.vpc.tf_private_subnet_us_east_1a_data
  private_subnet_1b_data = module.vpc.tf_private_subnet_us_east_1b_data
  tf_sg_rds              = module.vpc.tf_sg_rds
  password               = var.password
}

module "efs" {
  source                 = "./module/EFS"
  project_name           = var.project_name
  private_subnet_1a_data = module.vpc.tf_private_subnet_us_east_1a_data
  private_subnet_1b_data = module.vpc.tf_private_subnet_us_east_1b_data
  tf_sg_efs              = module.vpc.tf_sg_efs
}

module "asg" {
  source                = "./module/ASG"
  vpc_cidr              = module.vpc.tf_vpc
  ami_wordpress         = var.ami_wordpress
  project_name          = var.project_name
  load_balancers        = module.alb.tf_alb
  tf_sg_basionhost      = module.vpc.tf_sg_basionhost
  public_subnet_1a      = module.vpc.tf_public_subnet_us_east_1a
  load_balancers_arn    = module.alb.tf_alb_arn
  private_subnet_1a_app = module.vpc.tf_private_subnet_us_east_1a_app
  private_subnet_1b_app = module.vpc.tf_private_subnet_us_east_1b_app
}

module "alb" {
  source           = "./module/ALB"
  project_name     = var.project_name
  public_subnet_1a = module.vpc.tf_public_subnet_us_east_1a
  public_subnet_1b = module.vpc.tf_public_subnet_us_east_1b
  sg_alb           = module.vpc.tf_sg_alb
  target_group_arn = module.asg.target-groups-arn
}

module "elasticcache" {
  source                 = "./module/Elsaticache"
  project_name           = var.project_name
  private_subnet_1a_data = module.vpc.tf_private_subnet_us_east_1a_data
  private_subnet_1b_data = module.vpc.tf_private_subnet_us_east_1b_data
  tf_sg_elasticache      = module.vpc.tf_sg_elasticache
}