
resource "aws_eip" "ngw_eips" {
    count = "${var.required_az_count}"
    vpc   = true
}

resource "aws_nat_gateway" "ngws" {
    count         = "${var.required_az_count}"
    allocation_id = "${element(aws_eip.ngw_eips.*.id, count.index)}"
    subnet_id     = "${element(aws_subnet.dmz.*.id, count.index)}"

    tags = "${merge(var.default_tags, map("Name", "${var.project_accronym}-NGW-${count.index}"))}"
}

resource "aws_route_table" "ngw_route_tables" {

    count   = "${aws_nat_gateway.ngws.count}"
    vpc_id  = "${aws_vpc.vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${element(aws_nat_gateway.ngws.*.id, count.index)}"
    }

    tags = "${merge(var.default_tags, map("Name", "${var.project_accronym}-RT-NGW-${count.index}"))}"

}
