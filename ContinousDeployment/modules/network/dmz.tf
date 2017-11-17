
resource "aws_route_table" "igw_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = "${merge(var.default_tags, map("Name", "${var.project_accronym}-RT-IGW"))}"
}

resource "aws_subnet" "dmz" {
    count                   = "${var.required_az_count}"
    cidr_block              = "${element(var.dmz_cidrs,count.index)}"
    vpc_id                  = "${aws_vpc.vpc.id}"
    map_public_ip_on_launch = "true"
    availability_zone       = "${element(var.availability_zones,count.index)}"

    tags = "${merge(var.default_tags, map("Name", "${var.project_accronym}-DMZ-${count.index}"))}"
}

resource "aws_route_table_association" "route_table_dmz_bridge" {
    count           = "${var.required_az_count}"
    subnet_id       = "${element(aws_subnet.dmz.*.id, count.index)}"
    route_table_id  = "${aws_route_table.igw_route_table.id}"
}
