provider "aws" {
  region = var.region
}

# Setup Network Resources
module "vpc" {
  source                     = "./modules/network"
  vpc_cidr_block             = var.vpc_cidr_block
  availability_zones         = var.availability_zones
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
}
