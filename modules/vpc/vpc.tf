resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr_block}"

  tags {
    Name = "${var.name_tag}"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = "${var.number_public_subnets}"

  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${element(var.public_subnet_cidr, count.index)}"
  availability_zone       = "${element(data.aws_availability_zones.available.names, count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.name_tag}-pub-${element(data.aws_availability_zones.available.names, count.index)}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.name_tag}"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.main.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
}
