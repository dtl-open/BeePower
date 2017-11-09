###################################################
#           Application Load Balancer             #
###################################################

resource "aws_alb" "alb" {
    name                = "${var.project_accronym}-ALB"
    internal            = false
    security_groups     = ["${aws_security_group.elb-sg.id}"]
    subnets             = ["${aws_subnet.dmz.*.id}"]

    tags {
        Name = "${var.project_accronym}-ALB"
        Project = "${var.project_name}"
        Environment = "${var.environment}"
    }
}

resource "aws_alb_target_group" "default" {

    name        = "${var.project_accronym}-ALB-DEFAULT-TG"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = "${aws_vpc.vpc.id}"

    tags {
        Name = "${var.project_accronym}-ALB-DEFAULT-TG"
        Project = "${var.project_name}"
        Environment = "${var.environment}"
    }
}

resource "aws_alb_listener" "http" {
    load_balancer_arn   = "${aws_alb.alb.arn}"
    protocol            = "HTTP"
    port                = 80

    default_action {
        target_group_arn = "${aws_alb_target_group.default.arn}"
        type             = "forward"
    }
}
