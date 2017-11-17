output "vpc_id" {
    value = "${module.network.vpc_id}"
}

output "bastion_server_ip" {
    value = "${module.network.bastion_server_ip}"
}

output "ecs_nodes_ip" {
    value = "${module.ecs_cluster.ecs_nodes_ips}"
}

output "load_balancer_url" {
    value = "${module.ecs_cluster.load_balancer_url}"
}
