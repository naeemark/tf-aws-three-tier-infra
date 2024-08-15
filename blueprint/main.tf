provider "aws" {
  region  = var.region
  profile = var.profile
}

locals {
  tags = merge({ Env = var.tf_env }, var.tags)
}

# Setup IAM Resources
module "iam" {
  source = "./modules/iam"
  tags   = local.tags
}

# Setup Network Resources
module "network" {
  source                     = "./modules/network"
  vpc_cidr_block             = var.vpc_cidr_block
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
  frontend_sg_allow_ssh  = true
  backend_sg_allow_ssh   = true
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

# Web Application Firewall
module "waf" {
  source     = "./modules/waf"
  alb_arn    = module.load_balancer.alb_arn
  tags       = local.tags
  depends_on = [module.load_balancer]
}

# Database
# module "database" {
#   source                  = "./modules/database"
#   required_database_setup = var.required_database_setup
#   security_group_ids      = [module.security_groups.database_sg_id]
#   private_subnet_ids      = [module.network.private_subnet_1_id, module.network.private_subnet_2_id]
#   db_port                 = var.database_instance_port
#   tags                    = local.tags
#   tf_env = var.tf_env

#   depends_on = [
#     module.network,
#     module.security_groups
#   ]
# }

# Backend
module "backend" {
  source                    = "./modules/instances"
  ami_id                    = var.backend_ami_id
  instance_type             = var.backend_instance_type
  security_group_ids        = [module.security_groups.backend_sg_id]
  private_subnet_ids        = [module.network.private_subnet_1_id, module.network.private_subnet_2_id]
  iam_instance_profile_name = module.iam.instance_profile_name_backend
  alb_target_group_arns     = [module.load_balancer.backend_alb_target_group_arn]
  asg_name_prefix           = var.backend_asg_name_prefix
  user_data_script          = filebase64("${path.module}/../scripts/init_backend_server.sh")
  tags                      = local.tags

  depends_on = [
    module.iam,
    module.network,
    module.security_groups,
    module.load_balancer
  ]
}

# Frontend (Autoscalling Group)
module "frontend" {
  source                    = "./modules/instances"
  ami_id                    = var.frontend_ami_id
  instance_type             = var.frontend_instance_type
  security_group_ids        = [module.security_groups.frontend_sg_id]
  private_subnet_ids        = [module.network.private_subnet_1_id, module.network.private_subnet_2_id]
  iam_instance_profile_name = module.iam.instance_profile_name_frontend
  alb_target_group_arns     = [module.load_balancer.frontend_alb_target_group_arn]
  asg_name_prefix           = var.frontend_asg_name_prefix
  user_data_script          = filebase64("${path.module}/../scripts/init_frontend_server.sh")
  tags                      = local.tags

  depends_on = [
    module.iam,
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
  source                    = "./modules/bastion"
  required_bastion_setup    = var.required_bastion_setup
  ami_id                    = var.bastion_ami_id
  instance_type             = var.backend_instance_type
  security_group_ids        = [module.security_groups.bastion_sg_id]
  public_subnet_id          = module.network.public_subnet_1_id
  key_pair_name             = var.key_pair_name
  eip_id                    = module.network.bastion_eip_id
  iam_instance_profile_name = module.iam.instance_profile_name_backend
  user_data_script          = filebase64("${path.module}/../scripts/init_bastion_host.sh")
  tags                      = local.tags

  depends_on = [
    module.iam,
    module.network,
    module.security_groups
  ]
}
