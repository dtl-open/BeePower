
###################################################
#                 Bastion Server                  #
###################################################

resource "aws_instance" "bastion_server" {
  ami           = "ami-e2021d81"
  instance_type = "t2.micro"
  subnet_id     = "${element(aws_subnet.dmz.*.id, 0)}"
  vpc_security_group_ids = ["${aws_security_group.bastion-sg.id}"]
  key_name        = "${var.key_name}"

  tags {
    Name = "${var.project_accronym}-BASTION-SERVER"
    Project = "${var.project_name}"
    Environment = "${var.environment}"
  }
}
