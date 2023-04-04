###########################################################
# Backend Resources
###########################################################

resource "aws_instance" "backend" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[0]
  vpc_security_group_ids = var.security_group_ids
  user_data              = var.user_data_script
  key_name               = "devops-vm-keypair-2" # temp
  # associate_public_ip_address = true

  tags = {
    Name  = "tf-task-backend"
    Owner = "ccs_it"
  }
}
