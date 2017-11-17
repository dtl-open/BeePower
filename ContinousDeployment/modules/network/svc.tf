
resource "aws_subnet" "services" {

    count                   = "${var.required_az_count}"
    cidr_block              = "${element(var.services_subnet_cidrs,count.index)}"
    vpc_id                  = "${aws_vpc.vpc.id}"
    map_public_ip_on_launch = "false"
    availability_zone       = "${element(var.availability_zones,count.index)}"

    tags = "${merge(var.default_tags, map("Name", "${var.project_accronym}-SERVICES-${count.index}"))}"

}

resource "aws_route_table_association" "route_table_services_bridge" {

    count           = "${aws_subnet.services.count}"
    subnet_id       = "${element(aws_subnet.services.*.id, count.index)}"
    route_table_id  = "${element(aws_route_table.ngw_route_tables.*.id, count.index)}"
}
