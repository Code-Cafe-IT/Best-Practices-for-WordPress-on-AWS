# Create VPC
resource "aws_vpc" "tf_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true
  tags = {
    Name = "${var.project_name}-tf-vpc"
  }
}
# Create Subnet 

data "aws_availability_zones" "aws_availability_zones" {
  state = "available"
}


resource "aws_subnet" "tf_public_subnet_us_east_1a" {
  vpc_id = aws_vpc.tf_vpc.id
  cidr_block = var.public_subnet_1a
  availability_zone = data.aws_availability_zones.aws_availability_zones.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-tf-public-subnet-1a"
  }
}

resource "aws_subnet" "tf_public_subnet_us_east_1b" {
  vpc_id = aws_vpc.tf_vpc.id
  cidr_block = var.public_subnet_1b
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.aws_availability_zones.names[1]
  tags = {
    Name = "${var.project_name}-tf-public-subnet-1b"
  }
}


resource "aws_subnet" "tf_private_subnet_us_east_1a_app" {
  vpc_id = aws_vpc.tf_vpc.id
  cidr_block = var.private_subnet_1a_app
  availability_zone = data.aws_availability_zones.aws_availability_zones.names[0]
  tags = {
    Name = "${var.project_name}-tf-private-subnet-1a-app"
  }
}

resource "aws_subnet" "tf_private_subnet_us_east_1b_app" {
  vpc_id = aws_vpc.tf_vpc.id
  cidr_block = var.private_subnet_1b_app
  availability_zone = data.aws_availability_zones.aws_availability_zones.names[1]
  tags = {
    Name = "${var.project_name}-tf-private-subnet-1b-app"
  }
}


resource "aws_subnet" "tf_private_subnet_us_east_1a_data" {
  vpc_id = aws_vpc.tf_vpc.id
  cidr_block = var.private_subnet_1a_data
  availability_zone = data.aws_availability_zones.aws_availability_zones.names[0]
  tags = {
    Name = "${var.project_name}-tf-private-subnet-1a-data"
  }
}

resource "aws_subnet" "tf_private_subnet_us_east_1b_data" {
  vpc_id = aws_vpc.tf_vpc.id
  cidr_block = var.private_subnet_1b_data
  availability_zone = data.aws_availability_zones.aws_availability_zones.names[1]
  tags = {
    Name = "${var.project_name}-tf-private-subnet-1b-data"
  }
}
#Create InternetGateway



resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id
}

#Create NAT

resource "aws_eip" "tf_eip_1a" {
  domain = "vpc"
}

resource "aws_eip" "tf_eip_1b" {
  domain = "vpc"
}


resource "aws_nat_gateway" "tf_nat_1a" {
  allocation_id = aws_eip.tf_eip_1a.id
  subnet_id = aws_subnet.tf_public_subnet_us_east_1a.id
  depends_on = [ aws_internet_gateway.tf_igw ]
  tags = {
    Name = "${var.project_name}-tf-nat-1a"
  }
}

resource "aws_nat_gateway" "tf_nat_1b" {
  allocation_id = aws_eip.tf_eip_1b.id
  subnet_id = aws_subnet.tf_public_subnet_us_east_1b.id
  depends_on = [ aws_internet_gateway.tf_igw ]
  tags = {
    Name = "${var.project_name}-tf-nat-1b"
  }
}

#Create routable


resource "aws_route_table" "tf_public_rtb" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }
  tags = {
    Name = "${var.project_name}-tf-public-rtb"
  }
}

resource "aws_route_table" "tf_private_rtb_1a_app" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.tf_nat_1a.id
  }
  tags = {
    Name = "${var.project_name}-tf-private-rtb-1a-app"
  }
}

resource "aws_route_table" "tf_private_rtb_1b_app" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.tf_nat_1b.id
  }
  tags = {
    Name = "${var.project_name}-tf-private-rtb-1b-app"
  }
}

resource "aws_route_table" "tf_private_rtb_1a_data" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.tf_nat_1a.id
  }
  tags = {
    Name = "${var.project_name}-tf-private-rtb-1a-data"
  }
}

resource "aws_route_table" "tf_private_rtb_1b_data" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.tf_nat_1b.id
  }
  tags = {
    Name = "${var.project_name}-tf-private-rtb-1b-data"
  }
}

#Attach Routetable


resource "aws_route_table_association" "tf_att_public_rtb_1a" {
  route_table_id = aws_route_table.tf_public_rtb.id
  subnet_id = aws_subnet.tf_public_subnet_us_east_1a.id
}

resource "aws_route_table_association" "tf_att_public_rtb_1b" {
  route_table_id = aws_route_table.tf_public_rtb.id
  subnet_id = aws_subnet.tf_public_subnet_us_east_1b.id
}

#private

resource "aws_route_table_association" "tf_att_private_rtb_1a_app" {
  route_table_id = aws_route_table.tf_private_rtb_1a_app.id
  subnet_id = aws_subnet.tf_private_subnet_us_east_1a_app.id
}

resource "aws_route_table_association" "tf_att_private_rtb_1b_app" {
  route_table_id = aws_route_table.tf_private_rtb_1b_app.id
  subnet_id = aws_subnet.tf_private_subnet_us_east_1b_app.id
}

resource "aws_route_table_association" "tf_att_private_rtb_1a_data" {
  route_table_id = aws_route_table.tf_private_rtb_1a_data.id
  subnet_id = aws_subnet.tf_private_subnet_us_east_1a_data.id
}

resource "aws_route_table_association" "tf_att_private_rtb_1b_data" {
  route_table_id = aws_route_table.tf_private_rtb_1b_data.id
  subnet_id = aws_subnet.tf_private_subnet_us_east_1b_data.id
}


#Create Security Group

data "http" "my_ip" {
  url = "http://checkip.amazonaws.com"
}

resource "aws_security_group" "tf_basion_host" {
  vpc_id = aws_vpc.tf_vpc.id
  name = "tf-sg-basion"
  description = "basionhost"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_security_group" "tf_sg_alb" {
  vpc_id = aws_vpc.tf_vpc.id
  name = "tf-sg-alb"
  description = "Allow HTTP inbound traffic"
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.project_name}-tf-sg-alb"
  }
}

resource "aws_security_group" "tf_sg_asg" {
    name = "tf-sg-asg"
    description = "Allow SSH inbound traffic form my IP, HTTP form ALB"
  vpc_id = aws_vpc.tf_vpc.id
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    security_groups = [ aws_security_group.tf_basion_host.id ]
  }
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    security_groups = [ aws_security_group.tf_sg_alb.id ]
  }
  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    security_groups = [ aws_security_group.tf_sg_alb.id ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-tf-sg-asg"
  }
}


resource "aws_security_group" "tf_sg_rds" {
    name = "tf-sg-rds"
    description = "Allow port 3306 My SQL"
  vpc_id = aws_vpc.tf_vpc.id
  ingress {
    from_port = 3306
    protocol = "tcp"
    to_port = 3306
    security_groups = [ aws_security_group.tf_sg_asg.id ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-tf-sg-rds"
  }
}

resource "aws_security_group" "tf_sg_efs" {
    name = "tf-sg-efs"
    description = "Allow port 2049 efs"
  vpc_id = aws_vpc.tf_vpc.id
  ingress {
    from_port = 2049
    protocol = "tcp"
    to_port = 2049
    security_groups = [ aws_security_group.tf_sg_asg.id ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg-efs"
  }
}

resource "aws_security_group" "tf_sg_elasticache" {
  name        = "tf-sg-elasticache"
  description = "Security group for Elasticache"
  vpc_id      = aws_vpc.tf_vpc.id

  ingress {
    from_port   = 11211
    to_port     = 11211
    protocol    = "tcp"
    security_groups = [ aws_security_group.tf_sg_asg.id ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg-elasticache"
  }
}
