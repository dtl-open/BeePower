###################################################
#                ECS Cluster Nodes                #
###################################################

resource "aws_ecs_cluster" "ecs_cluster" {
    name = "${var.ecs_cluster_name}"
}

resource "aws_instance" "ecs_nodes" {
    count                   = 2
    ami                     = "ami-4f08e82d"
    instance_type           = "t2.micro"
    subnet_id               = "${element(aws_subnet.services.*.id, count.index)}"
    vpc_security_group_ids  = ["${aws_security_group.ecs_nodes-sg.id}"]
    key_name                = "${var.key_name}"
    iam_instance_profile    = "${var.ecs_instance_role_name}"

    tags {
      Name = "${var.project_accronym}-ECS-NODE-${count.index}"
      Project = "${var.project_name}"
      Environment = "${var.environment}"
    }

    user_data = <<-EOF
              #!/bin/bash
              echo "ECS_CLUSTER=${var.ecs_cluster_name}" > /etc/ecs/ecs.config
              EOF
}

resource "aws_cloudwatch_log_group" "meter_reads_logs" {

    name = "meter-reads-logs"

    tags {
      Name = "${var.project_accronym}-MeterReads-Logs"
      Project = "${var.project_name}"
      Environment = "${var.environment}"
    }
}
