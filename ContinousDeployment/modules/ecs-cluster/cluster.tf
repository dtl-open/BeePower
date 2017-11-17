
resource "aws_ecs_cluster" "ecs_cluster" {
    name = "${var.ecs_cluster_name}"
}

resource "aws_security_group" "ecs_nodes-sg" {
  name        = "${var.project_accronym}-SG-ECS-NODES"
  vpc_id      = "${var.vpc_id}"

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
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # outbound internet access
  egress {
      from_port     = 0
      to_port       = 0
      protocol      = "-1"
      cidr_blocks   = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "ecs_nodes" {
    count                   = "${var.ecs_node_instance_count}"
    ami                     = "ami-4f08e82d"
    instance_type           = "${var.ecs_node_instance_type}"
    subnet_id               = "${element(var.services_subnets, count.index)}"
    vpc_security_group_ids  = ["${aws_security_group.ecs_nodes-sg.id}"]
    key_name                = "${var.key_name}"
    iam_instance_profile    = "${var.ecs_instance_role_name}"

    tags = "${merge(var.default_tags, map("Name", "${var.project_accronym}-ECS-NODE-${count.index}"))}"

    user_data = <<-EOF
              #!/bin/bash
              echo "ECS_CLUSTER=${var.ecs_cluster_name}" > /etc/ecs/ecs.config
              EOF
}
