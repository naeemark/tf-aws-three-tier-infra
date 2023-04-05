###########################################################
# Backend Resources
###########################################################

resource "aws_instance" "backend" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[0]
  vpc_security_group_ids = var.security_group_ids
  user_data              = var.user_data_script
  key_name               = var.key_name # temp
  tags                   = merge({ Name = "tf-task-backend" }, var.tags)
}
