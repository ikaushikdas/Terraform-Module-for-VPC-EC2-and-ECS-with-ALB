provider "aws" {
  region = var.mod_region
}

module "vpc_module" {
  source         = "./modules/vpc"
  cidr_value     = var.mod_cidr
  zone_value     = var.mod_zone
  key_name_value = var.mod_key_name
  key_path_value = var.mod_key_path
  region         = var.mod_region
  vpc_name_value = var.vpc_name
}
module "ec2_module" {
  source              = "./modules/ec2"
  region              = var.mod_region
  ami_value           = var.mod_ami
  instance_type_value = var.mod_instance_type
  subnet_id_value     = module.vpc_module.public_subnet_id[1]
  key_name_value      = module.vpc_module.aws_key_pair
  sg_value            = module.vpc_module.security_group_id

}
module "alb_module" {
  source          = "./modules/alb"
  region          = var.mod_region
  subnet_id_value = module.vpc_module.public_subnet_id
  sg_value        = module.vpc_module.security_group_id
  vpc_id          = module.vpc_module.vpc_id
}
module "ecs_module" {
  source                     = "./modules/ecs"
  region                     = var.mod_region
  subnet_id_value            = module.vpc_module.public_subnet_id
  sg_value                   = module.vpc_module.security_group_id
  vpc_name                   = module.vpc_module.aws_vpc_name["Name"]
  vpc_id                     = module.vpc_module.vpc_id
  ecs_cluster_name_value     = var.ecs_cluster_name
  ecr_repository_name_value  = var.ecr_repository_name
  ecs_task_family_name_value = var.ecs_task_family_name
  ecs_service_name_value     = var.ecs_service_name
  ecs_container_name_value   = var.ecs_container_name
  alb_arn_value              = module.alb_module.alb_arn

}