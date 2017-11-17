output alb_http_listener_arn {
  value = "${aws_alb_listener.http.arn}"
}

output ecs_cluster_id {
  value = "${aws_ecs_cluster.ecs_cluster.id}"
}

output alb_arn {
  value = "${aws_alb.alb.arn}"
}

output "load_balancer_url" {
  value = "${aws_alb.alb.dns_name}"
}

output "ecs_nodes_ips" {
    value = "${aws_instance.ecs_nodes.*.private_ip}"
}
