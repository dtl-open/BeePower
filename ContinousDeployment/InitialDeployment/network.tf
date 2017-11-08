variable "vpc_address_space" {
  default = "10.0.0.0/16"
}

variable "subnet_dmz_address_space" {
    type    = "list"
    default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "subnet_services_address_space" {
    type    = "list"
    default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "subnet_dbs_address_space" {
    type    = "list"
    default = ["10.0.5.0/24", "10.0.6.0/24"]
}


data "aws_availability_zones" "available" {}

###################################################
#                    VPC                          #
###################################################

resource "aws_vpc" "vpc" {
    cidr_block = "${var.vpc_address_space }"

    tags {
        Name        = "${var.project_accronym}-VPC"
        Project     = "${var.project_name}"
        Environment = "${var.environment}"
    }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.project_accronym}-IGW"
    Project = "${var.project_name}"
    Environment = "${var.environment}"
  }
}

###################################################
#                    EIPs                         #
###################################################

resource "aws_eip" "ngw_eips" {
    count = 2
    vpc   = true
}


###################################################
#              DMZ Subnets (Public)               #
###################################################

resource "aws_route_table" "igw_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "${var.project_accronym}-RT-IGW"
    Project = "${var.project_name}"
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "dmz" {
    count                   = 2
    cidr_block              = "${element(var.subnet_dmz_address_space,count.index)}"
    vpc_id                  = "${aws_vpc.vpc.id}"
    map_public_ip_on_launch = "true"
    availability_zone       = "${element(data.aws_availability_zones.available.names,count.index)}"

  tags {
    Name = "${var.project_accronym}-DMZ-${count.index}"
    Project = "${var.project_name}"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "route_table_dmz_bridge" {
    count           = "${aws_subnet.dmz.count}"
    subnet_id       = "${element(aws_subnet.dmz.*.id, count.index)}"
    route_table_id  = "${aws_route_table.igw_route_table.id}"
}


###################################################
#                    NAT Gateways                 #
###################################################

# TODO check how to make NAT GW High Available

resource "aws_nat_gateway" "ngws" {
    count         = "${aws_eip.ngw_eips.count}"
    allocation_id = "${element(aws_eip.ngw_eips.*.id, count.index)}"
    subnet_id     = "${element(aws_subnet.dmz.*.id, count.index)}"

    tags {
        Name        = "${var.project_accronym}-NGW-${count.index}"
        Project     = "${var.project_name}"
        Environment = "${var.environment}"
    }
}

###################################################
#              NGW Route Tables                   #
###################################################

resource "aws_route_table" "ngw_route_tables" {

    count   = "${aws_nat_gateway.ngws.count}"
    vpc_id  = "${aws_vpc.vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${element(aws_nat_gateway.ngws.*.id, count.index)}"
    }

    tags {
        Name        = "${var.project_accronym}-RT-NGW-${count.index}"
        Project     = "${var.project_name}"
        Environment = "${var.environment}"
    }
}

###################################################
#              Services Subnets (Private)         #
###################################################

resource "aws_subnet" "services" {

    count                   = 2
    cidr_block              = "${element(var.subnet_services_address_space,count.index)}"
    vpc_id                  = "${aws_vpc.vpc.id}"
    map_public_ip_on_launch = "false"
    availability_zone       = "${element(data.aws_availability_zones.available.names,count.index)}"

    tags {
        Name        = "${var.project_accronym}-SERVICES-${count.index}"
        Project     = "${var.project_name}"
        Environment = "${var.environment}"
    }
}

resource "aws_route_table_association" "route_table_services_bridge" {

    count           = "${aws_subnet.services.count}"
    subnet_id       = "${element(aws_subnet.services.*.id, count.index)}"
    route_table_id  = "${element(aws_route_table.ngw_route_tables.*.id, count.index)}"
}

###################################################
#              Databases Subnets (Private)        #
###################################################

resource "aws_subnet" "dbs" {

    count                   = 2
    cidr_block              = "${element(var.subnet_dbs_address_space,count.index)}"
    vpc_id                  = "${aws_vpc.vpc.id}"
    map_public_ip_on_launch = "false"
    availability_zone       = "${element(data.aws_availability_zones.available.names,count.index)}"

    tags {
        Name        = "${var.project_accronym}-DBS-${count.index}"
        Project     = "${var.project_name}"
        Environment = "${var.environment}"
    }
}

resource "aws_route_table_association" "route_table_dbs_bridge" {

    count           = "${aws_subnet.dbs.count}"
    subnet_id       = "${element(aws_subnet.dbs.*.id, count.index)}"
    route_table_id  = "${element(aws_route_table.ngw_route_tables.*.id, count.index)}"
}
