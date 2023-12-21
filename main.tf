#VPC
resource "aws_vpc" "vpc" {
    cidr_block       = var.cidr_block
    instance_tenancy = var.instance_tenancy
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = merge(var.common_tags,{
                Name = "Minikube-VPC"
            })
}

#IG
resource "aws_internet_gateway" "IG" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(var.common_tags,{
            Name = "Minikube-IG"
        })
}

#Public subnet
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  count = length(var.public_subnet_cidr)
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = local.az[count.index]

  tags = merge(var.common_tags,{
            Name = var.public_subnet_name[count.index]
        })

}

#private subnet
resource "aws_subnet" "private" {
  vpc_id = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  count = length(var.private_subnet_cidr)
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = local.az[count.index]

  tags = merge(var.common_tags,{
            Name = var.private_subnet_name[count.index]
        })

}

# public route table
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.IG.id
    }

    tags = merge(var.common_tags,{
                Name = "minikube-Public-RT"
            })
}


resource "aws_route_table_association" "public" {
    count = length(var.public_subnet_cidr)
    subnet_id = element(aws_subnet.public[*].id, count.index)
    route_table_id = aws_route_table.public.id
}

# private route table
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.vpc.id

    tags = merge(var.common_tags,{
                Name = "Minikube-Private-RT"
            })
}


resource "aws_route_table_association" "private" {
    count = length(var.private_subnet_cidr)
    subnet_id = element(aws_subnet.private[*].id, count.index)
    route_table_id = aws_route_table.private.id
}

#SG
resource "aws_security_group" "sg" {
  name = "Minikube-SG"
  description = "SG"
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.ingress
    content {
      description = ingress.value.description
      from_port = ingress.value.from_port
      to_port = ingress.value.to_port
      protocol = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = merge(var.common_tags,{
                Name = "SG"
            })
}

# #EC2
 resource "aws_instance" "EC2" {
    ami = "ami-018ba43095ff50d08"
    instance_type = "t2.small"
    key_name = "provisioner"
    subnet_id = local.public_subnet_ids[0]
    security_groups = ["${aws_security_group.sg.id}"]
    user_data = file("K:/Devops/Practice/Docker-infra/scripts/docker.sh")
    tags = merge(var.common_tags,{
                Name = "Docker-workstation"
            })
}
