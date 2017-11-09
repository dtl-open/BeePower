###################################################
#         Bastion Security Group                  #
###################################################

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

###################################################
#             ELB Security Group                  #
###################################################

resource "aws_security_group" "elb-sg" {
  name        = "${var.project_accronym}-SG-ELB"
  vpc_id      = "${aws_vpc.vpc.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}

###################################################
#             ECS Nodes Security Group            #
###################################################

resource "aws_security_group" "ecs_nodes-sg" {
  name        = "${var.project_accronym}-SG-ECS-NODES"
  vpc_id      = "${aws_vpc.vpc.id}"

  # TCP access from ELB
  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = ["${aws_security_group.elb-sg.id}"]
  }

  # SSH access from vpc
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # outbound internet access
  egress {
      from_port     = 0
      to_port       = 0
      protocol      = "-1"
      cidr_blocks   = ["0.0.0.0/0"]
    }
}
