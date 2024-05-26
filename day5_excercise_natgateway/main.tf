# 1 . Created VPC
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  

  tags = {
    Name = "my-practice-vpc"
  }
}
# 2. Created 02 Subnets 
#2.1 create public subnet
resource "aws_subnet" "PUB" {
    cidr_block = "10.0.0.0/24"
    vpc_id = aws_vpc.main.id
    map_public_ip_on_launch = true
}
#2.2 create private subnet
resource "aws_subnet" "PRT" {
  cidr_block = "10.0.2.0/24"
    vpc_id = aws_vpc.main.id
    map_public_ip_on_launch = true
}
# 3. Created IGW
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
    tags = {
      Name = "igw"
    }
}
# 4. Created Route table and Route to IGW(edit route)
resource "aws_route_table" "RT" {
    vpc_id = aws_vpc.main.id
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
    
  }
  
}
# 5. Attached Route. #associate  RT to subnet(subnet association).... Created Instance associated PUBLIC Ip
resource "aws_route_table_association" "subassoc" {
    route_table_id = aws_route_table.RT.id
    subnet_id = aws_subnet.PUB.id
}
# 6. Created Security Group
resource "aws_security_group" "SG" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_tls"
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
#7. create elastic ip
resource "aws_eip" "nat_gateway" {
    domain = "vpc"
}
#create a nat-gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id = aws_subnet.PUB.id
  tags = {
    "Name" = "DummyNatGateway"
  }
}
#creating public ec2 with public ip address
resource "aws_instance" "main" {
  ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = [ aws_security_group.SG.id ]
    subnet_id = aws_subnet.PUB.id
    associate_public_ip_address = true
    tags = {
      Name = "prac-ec2-public"
    }

}
# 10. Created another Route table for getting Internet From public instance to private instance.
resource "aws_route_table" "PRT-RT" {
    vpc_id = aws_vpc.main.id
    route {
    cidr_block = "0.0.0.0/0"
   nat_gateway_id = aws_nat_gateway.nat_gateway.id
    
  }
  tags = {
    Name = "prt-natgtway"
  }
}
# 11. Attached Nat Gateway(subnet association)
resource "aws_route_table_association" "prt-subassoc" {
    route_table_id = aws_route_table.PRT-RT.id
    subnet_id = aws_subnet.PRT.id
}
# 12. Created another instance . WHICH IS prt-ec2 insatnce
resource "aws_instance" "main1" {
  ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = [ aws_security_group.SG.id ]
subnet_id = aws_subnet.PRT.id
    tags = {
      Name = "prac-ec2-private"
    }

}
