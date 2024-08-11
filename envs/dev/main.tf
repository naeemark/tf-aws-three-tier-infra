terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3"
    }
  }

  #############################################################
  ## AFTER RUNNING TERRAFORM APPLY (WITH LOCAL BACKEND)
  ## PLEASE UNCOMMENT THIS CODE THEN RERUN TERRAFORM INIT
  ## TO SWITCH FROM LOCAL BACKEND TO REMOTE AWS BACKEND

  ## [Commented code to avoid using remote backbackend]
  ## [ Will work if the resources are already created ]
  #############################################################
  # backend "s3" {
  #   bucket         = "bbeans-tfstate-bucket-${var.tf_env}"
  #   key            = "envs/dev/terraform.tfstate"
  #   region         = var.region
  #   dynamodb_table = "bbeans-state-locking-table-${var.tf_env}"
  #   encrypt        = true
  # }
}

module "dev_infra" {
  source                  = "../../blueprint"
  tf_env                  = var.tf_env
  region                  = var.region
  required_database_setup = false # Controls RDS instance Setup
  required_bastion_setup  = true  # Controls Bastion Host Setup
}
