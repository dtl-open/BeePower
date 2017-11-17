
resource "aws_security_group" "elb-sg" {
  name        = "${var.project_accronym}-SG-ELB"
  vpc_id      = "${var.vpc_id}"

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

resource "aws_alb" "alb" {
    name                = "${var.project_accronym}-ALB"
    internal            = false
    security_groups     = ["${aws_security_group.elb-sg.id}"]
    subnets             = ["${var.dmz_subnets}"]

    tags = "${merge(var.default_tags, map("Name", "${var.project_accronym}-ALB"))}"
}

resource "aws_alb_target_group" "default" {

    name        = "${var.project_accronym}-ALB-DEFAULT-TG"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = "${var.vpc_id}"

    tags = "${merge(var.default_tags, map("Name", "${var.project_accronym}-ALB-DEFAULT-TG"))}"
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
