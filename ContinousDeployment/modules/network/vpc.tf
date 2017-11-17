
resource "aws_vpc" "vpc" {

    cidr_block = "${var.vpc_cidr }"
    tags = "${merge(var.default_tags, map("Name", "${var.project_accronym}-VPC"))}"

}

resource "aws_internet_gateway" "igw" {

  vpc_id = "${aws_vpc.vpc.id}"
  tags = "${merge(var.default_tags, map("Name", "${var.project_accronym}-IGW"))}"

}
