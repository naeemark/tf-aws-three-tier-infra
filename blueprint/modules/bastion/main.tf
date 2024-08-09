
###########################################################
# Bastion/Jump Server Configs 
###########################################################
resource "aws_instance" "bastion" {
  count                       = var.required_bastion_setup ? 1 : 0 # Condition to control Bastion Host Creation
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = true
  key_name                    = var.key_pair_name
  user_data                   = var.user_data_script
  tags                        = merge({ Name = "bbeans-bastion-host" }, var.tags)
}

# Associate the Elastic IP with the EC2 instance
resource "aws_eip_association" "eip_association" {
  instance_id   = aws_instance.bastion[0].id
  allocation_id = var.eip_id
}

