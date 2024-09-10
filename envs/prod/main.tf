terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60.0"
    }
  }

  #############################################################
  ## KEEP IT COMMENTED WHILE DOING EXPERIMATATION
  ## AFTER RUNNING TERRAFORM APPLY (WITH LOCAL BACKEND)
  ## PLEASE UNCOMMENT THIS CODE THEN RERUN `terraform init`
  ## TO SWITCH FROM LOCAL BACKEND TO REMOTE AWS BACKEND

  ## [Commented code to avoid using remote backend]
  ## [ Will work if the resources are already created ]
  #############################################################
  backend "s3" {
    bucket         = "bbeans-tfstate-bucket-prd"
    key            = "envs/prd/terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "bbeans-state-locking-table-prd"
    encrypt        = true
    profile        = "bbeans"
  }
}

module "prod_infra" {
  source                  = "../../blueprint"
  tf_env                  = var.tf_env
  region                  = var.region
  env_ami_id              = var.env_ami_id
  profile                 = "bbeans"
  required_database_setup = true # Controls RDS instance Setup
  required_bastion_setup  = true # Controls Bastion Host Setup
}
