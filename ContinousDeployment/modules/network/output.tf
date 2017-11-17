output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "igw_id" {
  value = "${aws_internet_gateway.igw.id}"
}

output "vpc_cidr" {
  value = "${aws_vpc.vpc.cidr_block}"
}

output "bastion_server_ip" {
  value = "${aws_instance.bastion_server.public_ip}"
}

output "dmz_subnet_ids" {
  value = "${aws_subnet.dmz.*.id}"
}

output "ngw_route_table_ids" {
  value = "${aws_route_table.ngw_route_tables.*.id}"
}

output "svc_subnet_ids" {
  value = "${aws_subnet.services.*.id}"
}
