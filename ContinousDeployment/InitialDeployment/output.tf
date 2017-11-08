###################################################
#                     Outputs                     #
###################################################

output "vpc_id" {
    value = "${aws_vpc.vpc.id}"
}

output "bastion_server_ip" {
    value = "${aws_instance.bastion_server.public_ip}"
}

output "ecs_cluster_id" {
    value = "${aws_ecs_cluster.ecs_cluster.id}"
}

output "ecs_nodes_ip" {
    value = "${aws_instance.ecs_nodes.*.private_ip}"
}

output "load_balancer_url" {
    value = "${aws_alb.alb.dns_name}"
}


output "alb_target_group_meter_reads_arn" {
    value = "${aws_alb_target_group.meter_reads.arn}"
}
