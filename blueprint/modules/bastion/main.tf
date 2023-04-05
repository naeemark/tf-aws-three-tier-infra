
###########################################################
# Bastion Configs 
###########################################################
resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = true
  key_name                    = var.bastion_key_name
  user_data                   = var.user_data_script

  tags = {
    Name  = "tf-task-bastion"
    Owner = "ccs_it"
  }
}

