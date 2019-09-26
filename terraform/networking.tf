resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${terraform.workspace}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "main"
  }
}

#public subnets AZ-1
resource "aws_subnet" "public_1" {
  count                   = length(var.public_subnets_1)
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.public_subnets_1[count.index]}"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "${terraform.workspace} Public ${var.public_subnets_1[count.index]} Subnet"
  }
}

#public subnets AZ-2
resource "aws_subnet" "public_2" {
  count                   = length(var.public_subnets_2)
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.public_subnets_2[count.index]}"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"

  tags = {
    Name = "${terraform.workspace} Public ${var.public_subnets_2[count.index]} Subnet"
  }
}

#private subnets
resource "aws_subnet" "private_1" {
  count             = length(var.private_subnets_1)
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.private_subnets_1[count.index]}"
  availability_zone = "us-east-1c"

  tags = {
    Name = "${terraform.workspace} Private ${var.private_subnets_1[count.index]} Subnet"
  }
}

resource "aws_route_table" "public_subnets" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags = {
    Name = "${terraform.workspace} public subnets"
  }
}

resource "aws_route_table_association" "public_subnets_1" {
  count          = 2
  subnet_id      = "${aws_subnet.public_1[count.index].id}"
  route_table_id = "${aws_route_table.public_subnets.id}"
}

resource "aws_route_table_association" "public_subnets_2" {
  count          = 2
  subnet_id      = "${aws_subnet.public_2[count.index].id}"
  route_table_id = "${aws_route_table.public_subnets.id}"
}

resource "aws_eip" "nat_gateway" {
  vpc = true
}

#resource "aws_nat_gateway" "gw" {
#  allocation_id = "${aws_eip.nat_gateway.id}"
#  subnet_id     = "${aws_subnet.public_1[0].id}"
#}

resource "aws_route_table_association" "private_subnets" {
  count          = 2
  subnet_id      = "${aws_subnet.private_1[count.index].id}"
  route_table_id = "${aws_vpc.main.main_route_table_id}"
}

#resource "aws_route" "private_subnets_to_nat_gateway" {
#  route_table_id         = "${aws_vpc.main.default_route_table_id}"
#  destination_cidr_block = "0.0.0.0/0"
#  nat_gateway_id = "${aws_nat_gateway.gw.id}"
#}
