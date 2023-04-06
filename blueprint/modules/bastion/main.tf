
###########################################################
# Bastion Configs 
###########################################################
resource "aws_instance" "bastion" {
  count                       = var.required_bastion_setup ? 1 : 0 # Condition to control Bastion Host Creation
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = true
  key_name                    = var.bastion_key_name
  user_data                   = var.user_data_script
  tags                        = merge({ Name = "tf-task-bastion" }, var.tags)

  #  To pass arguments as vars
  # user_data_base64 = base64encode("${templatefile("${path.module}/../scripts/init_bastion_host.sh", {
  #   DB_ENDPOINT = var.database_endpoint
  # })}")
}

