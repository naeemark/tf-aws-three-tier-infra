terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3"
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
    bucket         = "bbeans-tfstate-bucket-dev"
    key            = "envs/dev/terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "bbeans-state-locking-table-dev"
    encrypt        = true
    profile        = "muaksite"
  }
}

module "dev_infra" {
  source                  = "../../blueprint"
  tf_env                  = var.tf_env
  region                  = var.region
  required_database_setup = false # Controls RDS instance Setup
  required_bastion_setup  = true  # Controls Bastion Host Setup
}
