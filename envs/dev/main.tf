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
  #   bucket         = "tf-task-tfstate-bucket"
  #   key            = "envs/dev/terraform.tfstate"
  #   region         = "us-west-1"
  #   dynamodb_table = "tf-task-state-locking-table"
  #   encrypt        = true
  # }
}

module "dev_infra" {
  source                 = "../../blueprint"
  tf_env                 = var.tf_env
  region                 = var.region
  required_bastion_setup = false # Controls Bastion Host Setup
}
