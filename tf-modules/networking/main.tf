/*-----------------------------------------------------------------------
  For understanding the components involved in aws networking
  Ref: https://docs.aws.amazon.com/vpc/latest/userguide/how-it-works.html
/*-----------------------------------------------------------------------

/*-----------------------------
  Resource: VPC
  For: Virtual Network for EKS
------------------------------*/

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = "${var.environment}"
  }
}

/*-------------------------------------------------------------------------------
  Resource: Internet Gateway
  For: Public Subnets
  Ref: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html
---------------------------------------------------------------------------------*/

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.environment}-igw"
    Environment = "${var.environment}"
  }
}

/*--------------------
  Resource: Elastic IP
  For: NAT
----------------------*/

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

/*--------------------------------------------------------------------------
  Resource: NAT
  For: Private Subnets
  Ref: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html
----------------------------------------------------------------------------*/

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
  depends_on    = [aws_subnet.public_subnet]

  tags = {
    Name        = "nat"
    Environment = "${var.environment}"
  }
}

/*-----------------------
  Resource: Public subnet
-------------------------*/

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnets_cidr)
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${var.environment}-${element(var.availability_zones, count.index)}-public-subnet"
    Environment              = "${var.environment}"
    "kubernetes.io/role/elb" = "1"
  }
}

/*-----------------------
  Resource: Private subnet
-------------------------*/

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.private_subnets_cidr)
  cidr_block              = element(var.private_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name                              = "${var.environment}-${element(var.availability_zones, count.index)}-private-subnet"
    Environment                       = "${var.environment}"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

/*---------------------
  Resource: Route Table
  For: private subnet
-----------------------*/

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.environment}-private-route-table"
    Environment = "${var.environment}"
  }
}

/*---------------------
  Resource: Route Table
  For: public subnet
-----------------------*/

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.environment}-public-route-table"
    Environment = "${var.environment}"
  }
}

/*-----------------------------------------------------------
  Resource: aws route
  For: association of public route table and internet gateway
-------------------------------------------------------------*/

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}

/*-----------------------------------------------------------
  Resource: aws route
  For: association of private route table and nat gateway
-------------------------------------------------------------*/

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

/*-----------------------------------------------------------
  Resources: route table associations
  For: association of subnets and route tabless
-------------------------------------------------------------*/

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

/*--------------------------------------------------------------------------
  Resource: Security Group
  For: VPC
  Purpose: securing ports and inbound, outbound traffic
  Ref: https://docs.aws.amazon.com/vpc/latest/userguide/security-groups.html
----------------------------------------------------------------------------*/

resource "aws_security_group" "default" {
  name        = "${var.environment}-default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc]

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    self        = true
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    self        = "true"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = "${var.environment}"
  }
}
