resource "aws_security_group" "bastion-sg" {
  name        = "${var.project_accronym}-SG-BASTION"
  vpc_id      = "${aws_vpc.vpc.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion_server" {
  ami                       = "ami-e2021d81"
  instance_type             = "t2.micro"
  subnet_id                 = "${element(aws_subnet.dmz.*.id, 0)}"
  vpc_security_group_ids    = ["${aws_security_group.bastion-sg.id}"]
  key_name                  = "${var.key_name}"

  tags = "${merge(var.default_tags, map("Name", "${var.project_accronym}-BASTION"))}"
}
