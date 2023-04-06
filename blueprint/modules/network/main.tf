###########################################################
# Network Resources
###########################################################


# Create VPC
resource "aws_vpc" "task_vpc" {
  cidr_block = var.vpc_cidr_block
  tags       = merge({ Name = "tf-task-vpc" }, var.tags)
}

# Create Public Subnet1
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.task_vpc.id
  cidr_block              = var.public_subnet_cidr_blocks[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true
  tags                    = merge({ Name = "tf-task-public-subnet-1" }, var.tags)
}

# Create Public Subnet2

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.task_vpc.id
  cidr_block              = var.public_subnet_cidr_blocks[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true
  tags                    = merge({ Name = "tf-task-public-subnet-2" }, var.tags)
}

# Create Private Subnet1
resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.task_vpc.id
  cidr_block              = var.private_subnet_cidr_blocks[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = false
  tags                    = merge({ Name = "tf-task-private-subnet-1" }, var.tags)
}

# Create Private Subnet2
resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.task_vpc.id
  cidr_block              = var.private_subnet_cidr_blocks[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false
  tags                    = merge({ Name = "tf-task-private-subnet-2" }, var.tags)

}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.task_vpc.id
  tags   = merge({ Name = "tf-task-internet-gateway" }, var.tags)

}

# Create Public Route Table
resource "aws_route_table" "public_subnet_1_rt" {
  vpc_id = aws_vpc.task_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge({ Name = "tf-task-public-subnet-route-table" }, var.tags)
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
resource "aws_eip" "eip_natgw1" {
  count = "1"
  tags  = merge({ Name = "tf-task-eip-1" }, var.tags)
}

# Create NAT gateway1
resource "aws_nat_gateway" "natgateway_1" {
  count         = "1"
  allocation_id = aws_eip.eip_natgw1[count.index].id
  subnet_id     = aws_subnet.public_subnet_1.id
  tags          = merge({ Name = "tf-task-natgateway-1" }, var.tags)
}

# Create EIP for NAT GW2
resource "aws_eip" "eip_natgw2" {
  count = "1"
  tags  = merge({ Name = "tf-task-eip-2" }, var.tags)
}

# Create NAT gateway2
resource "aws_nat_gateway" "natgateway_2" {
  count         = "1"
  allocation_id = aws_eip.eip_natgw2[count.index].id
  subnet_id     = aws_subnet.public_subnet_2.id
  tags          = merge({ Name = "tf-task-natgateway-2" }, var.tags)
}

# Create private route table for private_subnet_1
resource "aws_route_table" "private_subnet_1_rt" {
  count  = "1"
  vpc_id = aws_vpc.task_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgateway_1[count.index].id
  }
  tags = merge({ Name = "tf-task-private-subnet-1-route-table" }, var.tags)
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
  vpc_id = aws_vpc.task_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgateway_2[count.index].id
  }
  tags = merge({ Name = "tf-task-private-subnet-2-route-table" }, var.tags)
}

# Create route table association between private_subnet_2 & NAT GW2
resource "aws_route_table_association" "private_subnet_2_to_natgw1" {
  count          = "1"
  route_table_id = aws_route_table.private_subnet_2_rt[count.index].id
  subnet_id      = aws_subnet.private_subnet_2.id
}
