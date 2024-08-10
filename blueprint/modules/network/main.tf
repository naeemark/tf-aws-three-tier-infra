###########################################################
# Network Resources
###########################################################


# Declare the data source for availability_zones
data "aws_availability_zones" "azs" {
  state = "available"
}

# Create VPC
resource "aws_vpc" "bbeans_vpc" {
  cidr_block = var.vpc_cidr_block
  tags       = merge({ Name = "bbeans-vpc-${var.tf_env}" }, var.tags)
}

# Create Public Subnet1
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.bbeans_vpc.id
  cidr_block              = var.public_subnet_cidr_blocks[0]
  availability_zone       = data.aws_availability_zones.azs.names[0]
  map_public_ip_on_launch = true
  tags                    = merge({ Name = "bbeans-public-subnet-1-${var.tf_env}" }, var.tags)
}

# Create Public Subnet2

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.bbeans_vpc.id
  cidr_block              = var.public_subnet_cidr_blocks[1]
  availability_zone       = data.aws_availability_zones.azs.names[1]
  map_public_ip_on_launch = true
  tags                    = merge({ Name = "bbeans-public-subnet-2-${var.tf_env}" }, var.tags)
}

# Create Private Subnet1
resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.bbeans_vpc.id
  cidr_block              = var.private_subnet_cidr_blocks[0]
  availability_zone       = data.aws_availability_zones.azs.names[0]
  map_public_ip_on_launch = false
  tags                    = merge({ Name = "bbeans-private-subnet-1-${var.tf_env}" }, var.tags)
}

# Create Private Subnet2
resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.bbeans_vpc.id
  cidr_block              = var.private_subnet_cidr_blocks[1]
  availability_zone       = data.aws_availability_zones.azs.names[1]
  map_public_ip_on_launch = false
  tags                    = merge({ Name = "bbeans-private-subnet-2-${var.tf_env}" }, var.tags)
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.bbeans_vpc.id
  tags   = merge({ Name = "bbeans-igw-${var.tf_env}" }, var.tags)

}

# Create Public Route Table
resource "aws_route_table" "public_subnet_1_rt" {
  vpc_id = aws_vpc.bbeans_vpc.id

  route {
    cidr_block = var.anywhere_cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge({ Name = "bbeans-public-subnet-rt-${var.tf_env}" }, var.tags)
}

# Create route table association of public subnet1
resource "aws_route_table_association" "internet_for_public_subnet_1" {
  route_table_id = aws_route_table.public_subnet_1_rt.id
  subnet_id      = aws_subnet.public_subnet_1.id
}

# Create route table association of public subnet2
resource "aws_route_table_association" "internet_for_public_subnet_2" {
  route_table_id = aws_route_table.public_subnet_1_rt.id
  subnet_id      = aws_subnet.public_subnet_2.id
}

# Create EIP for NAT GW1
resource "aws_eip" "natgw1_eip" {
  count = "1"
  tags  = merge({ Name = "bbeans-natgw-eip-1-${var.tf_env}" }, var.tags)
}

# Create EIP for NAT GW2
resource "aws_eip" "natgw2_eip" {
  count = "1"
  tags  = merge({ Name = "bbeans-natgw-eip-2-${var.tf_env}" }, var.tags)
}

# Create EIP for Bastion Host
resource "aws_eip" "bastion_eip" {
  tags = merge({ Name = "bbeans-bastion-eip-${var.tf_env}" }, var.tags)
}

# Create NAT gateway1
resource "aws_nat_gateway" "natgateway_1" {
  count         = "1"
  allocation_id = aws_eip.natgw1_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet_1.id
  tags          = merge({ Name = "bbeans-natgw-eip-1-${var.tf_env}" }, var.tags)
}

# Create NAT gateway2
resource "aws_nat_gateway" "natgateway_2" {
  count         = "1"
  allocation_id = aws_eip.natgw2_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet_2.id
  tags          = merge({ Name = "bbeans-natgw-eip-2-${var.tf_env}" }, var.tags)
}

# Create private route table for private_subnet_1
resource "aws_route_table" "private_subnet_1_rt" {
  count  = "1"
  vpc_id = aws_vpc.bbeans_vpc.id
  route {
    cidr_block     = var.anywhere_cidr_block
    nat_gateway_id = aws_nat_gateway.natgateway_1[count.index].id
  }
  tags = merge({ Name = "bbeans-private-subnet-1-rt-${var.tf_env}" }, var.tags)
}

# Create route table association between private_subnet_1 & NAT GW1
resource "aws_route_table_association" "private_subnet_1_to_natgw1" {
  count          = "1"
  route_table_id = aws_route_table.private_subnet_1_rt[count.index].id
  subnet_id      = aws_subnet.private_subnet_1.id
}

# Create private route table for private_subnet_2
resource "aws_route_table" "private_subnet_2_rt" {
  count  = "1"
  vpc_id = aws_vpc.bbeans_vpc.id
  route {
    cidr_block     = var.anywhere_cidr_block
    nat_gateway_id = aws_nat_gateway.natgateway_2[count.index].id
  }
  tags = merge({ Name = "bbeans-private-subnet-2-rt-${var.tf_env}" }, var.tags)
}

# Create route table association between private_subnet_2 & NAT GW2
resource "aws_route_table_association" "private_subnet_2_to_natgw1" {
  count          = "1"
  route_table_id = aws_route_table.private_subnet_2_rt[count.index].id
  subnet_id      = aws_subnet.private_subnet_2.id
}
