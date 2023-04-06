provider "aws" {
  region = var.region
}

locals {
  tags = merge({ Env = var.tf_env }, var.tags)
}

# Setup Network Resources
module "network" {
  source                     = "./modules/network"
  vpc_cidr_block             = var.vpc_cidr_block
  availability_zones         = var.availability_zones
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  tags                       = local.tags
}

# Setup Security Groups
module "security_groups" {
  source                 = "./modules/security_groups"
  vpc_id                 = module.network.vpc_id
  database_instance_port = var.database_instance_port
  required_bastion_setup = var.required_bastion_setup
  alb_sg_allow_http      = true
  frontend_sg_allow_ssh  = false
  backend_sg_allow_ssh   = false
  tags                   = local.tags

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
  tags               = local.tags

  depends_on = [
    module.network,
    module.security_groups
  ]
}

# Database
module "database" {
  source             = "./modules/database"
  security_group_ids = [module.security_groups.database_sg_id]
  private_subnet_ids = [module.network.private_subnet_1_id, module.network.private_subnet_2_id]
  db_port            = var.database_instance_port
  tags               = local.tags

  depends_on = [
    module.network,
    module.security_groups
  ]
}

# Backend
module "backend" {
  source             = "./modules/backend"
  ami_id             = var.backend_ami_id
  instance_type      = var.backend_instance_type
  security_group_ids = [module.security_groups.database_sg_id]
  private_subnet_ids = [module.network.private_subnet_1_id, module.network.private_subnet_2_id]
  database_endpoint  = module.database.endpoint
  user_data_script   = filebase64("${path.module}/../scripts/init_backend_server.sh")
  tags               = local.tags

  depends_on = [
    module.network,
    module.security_groups,
    module.database
  ]
}

# Frontend (Autoscalling Group)
module "frontend" {
  source                = "./modules/frontend"
  ami_id                = var.frontend_ami_id
  instance_type         = var.frontend_instance_type
  security_group_ids    = [module.security_groups.frontend_sg_id]
  alb_target_group_arns = [module.load_balancer.alb_target_group_arn]
  private_subnet_ids    = [module.network.private_subnet_1_id, module.network.private_subnet_2_id]
  user_data_script      = filebase64("${path.module}/../scripts/init_frontend_server.sh")
  backend_private_ip    = module.backend.private_ip
  tags                  = local.tags

  depends_on = [
    module.network,
    module.security_groups,
    module.load_balancer,
    module.backend
  ]
}


###########################################################
# Bastion Configs [Temporary - To test in VPC]
###########################################################
module "bastion" {
  source                 = "./modules/bastion"
  required_bastion_setup = var.required_bastion_setup
  ami_id                 = var.backend_ami_id
  instance_type          = var.backend_instance_type
  security_group_ids     = [module.security_groups.bastion_sg_id]
  public_subnet_id       = module.network.public_subnet_1_id
  bastion_key_name       = var.bastion_key_name
  user_data_script       = filebase64("${path.module}/../scripts/init_bastion_host.sh")
  database_endpoint      = module.database.endpoint
  backend_private_ip     = module.backend.private_ip
  backend_public_ip      = module.backend.public_ip
  tags                   = local.tags

  depends_on = [
    module.network,
    module.security_groups,
    module.database,
    module.backend
  ]
}
