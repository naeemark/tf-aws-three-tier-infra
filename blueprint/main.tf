provider "aws" {
  region = var.region
}

# Setup Network Resources
module "network" {
  source                     = "./modules/network"
  vpc_cidr_block             = var.vpc_cidr_block
  availability_zones         = var.availability_zones
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
}

# Setup Security Groups
module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.network.vpc_id

  depends_on = [
    module.network
  ]
}

# Application Load Balancer
module "load_balancer" {
  source             = "./modules/load_balancer"
  vpc_id             = module.network.vpc_id
  security_group_ids = [module.security_groups.alb_sg_id]
  public_subnet_ids  = [module.network.public_subnet_1_id, module.network.public_subnet_2_id]

  depends_on = [
    module.network,
    module.security_groups
  ]
}

# Frontend (Autoscalling Group)
module "frontend" {
  source                = "./modules/frontend"
  ami_id                = var.frontend_ami_id
  instance_type         = var.frontend_instance_type
  security_group_ids    = ["${module.security_groups.frontend_sg_id}"]
  alb_target_group_arns = [module.load_balancer.alb_target_group_arn]
  private_subnet_ids    = [module.network.private_subnet_1_id, module.network.private_subnet_2_id]
  user_data_script      = filebase64("${path.module}/../scripts/init_frontend_server.sh")

  depends_on = [
    module.network,
    module.security_groups,
    module.load_balancer
  ]
}
