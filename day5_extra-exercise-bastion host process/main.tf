# public network
# create custom vpc
resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name ="terraform_vpc"
  }
}
# create public subnet
resource "aws_subnet" "custom-public-subnet" {
    cidr_block = "10.0.0.0/24"
    vpc_id = aws_vpc.custom_vpc.id
    map_public_ip_on_launch = true
}
# create route table(public)  and # attach public route table to subnet(edit route)
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public-ig.id
    
  }
  
}
# create internet gateway(public) and attach to vpc
resource "aws_internet_gateway" "public-ig" {
  vpc_id = aws_vpc.custom_vpc.id
}
#attach (public subnet association)
resource "aws_route_table_association" "public-assciation" {
    route_table_id = aws_route_table.public-rt.id
    subnet_id = aws_subnet.custom-public-subnet.id
}

#create security groups  and attach to both pub and prt
resource "aws_security_group" "SG" {
  name        = "allow_tls"
  vpc_id      = aws_vpc.custom_vpc.id
  tags = {
    Name = "Terraform-sg"
  }
 ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }
egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }


  }
  #create public ec2 in public subnet
  resource "aws_instance" "public-ec2" {
  ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = [ aws_security_group.SG.id ]
    subnet_id = aws_subnet.custom-public-subnet.id
    associate_public_ip_address = true
    tags = {
      Name = "custom-ec2-public"
    }
  }

# private network
# create private subnet 
resource "aws_subnet" "custom-private-subnet" {
    cidr_block = "10.0.2.0/24"
    vpc_id = aws_vpc.custom_vpc.id
    map_public_ip_on_launch = true
}
# create nat gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.custom-public-subnet.id

  tags = {
    Name = "gw NAT"
  }
}
# alloacte a elastic ip
resource "aws_eip" "nat_gateway" {
  domain   = "vpc"
}
# create route table(prt)--(edit route) and # attach natgateway to prt route table
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
    
  }
  
}
# attach route table to prt subnet(subnet association)
 resource "aws_route_table_association" "prt-sb-assciation" {
    route_table_id = aws_route_table.private-rt.id
    subnet_id = aws_subnet.custom-private-subnet.id
}
# create a private ec2 instance
resource "aws_instance" "private-ec2" {
  ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = [ aws_security_group.SG.id ]
    subnet_id = aws_subnet.custom-private-subnet.id
    associate_public_ip_address = false
    tags = {
      Name = "custom-ec2-private"
    }
  }
