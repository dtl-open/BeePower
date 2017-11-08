###################################################
#              Meter Reads API Service            #
###################################################

resource "aws_ecs_task_definition" "meter_reads" {

    family                = "MeterReads"
    container_definitions = "${file("../TaskDefinitions/meterReadsApi.json")}"

}

resource "aws_ecs_service" "meter_reads" {

    name            = "MeterReadsService"
    cluster         = "${var.ecs_cluster_id}"
    task_definition = "${aws_ecs_task_definition.meter_reads.id}"
    desired_count   = 2
    iam_role        = "${var.ecs_service_iam_role}"

    placement_strategy {
        type    = "spread"
        field   = "attribute:ecs.availability-zone"
    }

    load_balancer {
        container_name      = "meterReadsContainer"
        container_port      = 80
        target_group_arn    = "${var.alb_target_group_meter_reads_arn}"
    }
}

# resource "aws_alb_target_group" "meter_reads" {
#     name        = "${var.project_accronym}-MeterReads-TG"
#     port        = 80
#     protocol    = "HTTP"
#     vpc_id      = "${var.vpc_id}"
#
#     health_check {
#       protocol  = "HTTP"
#       path      = "/api/meterReads"
#       matcher   = "200-299"
#     }
#
#     tags {
#         Name        = "${var.project_accronym}-MeterReads-TG"
#         Project     = "${var.project_name}"
#         Environment = "${var.environment}"
#     }
# }
#
# resource "aws_alb_listener_rule" "meter_reads" {
#     listener_arn  = "${var.load_balancer_http_listener_arn}"
#     priority      = 1
#
#     action {
#         type             = "forward"
#         target_group_arn = "${aws_alb_target_group.meter_reads.arn}"
#     }
#
#     condition {
#         field  = "path-pattern"
#         values = ["/api/meterReads"]
#     }
# }
