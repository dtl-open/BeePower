data "aws_availability_zones" "available" {}

module "network" {
  source    = "../../modules/network"

  vpc_cidr              = "${var.vpc_cidr}"
  required_az_count     = "${var.required_az_count}"
  dmz_cidrs             = "${var.dmz_subnet_cidrs}"
  services_subnet_cidrs = "${var.services_subnet_cidrs}"
  availability_zones    = "${data.aws_availability_zones.available.names}"
  project_accronym      = "${var.project_accronym}"
  default_tags          = "${var.default_tags}"
  key_name              = "${var.key_name}"
}

module "ecs_cluster" {
  source = "../../modules/ecs-cluster"

  vpc_cidr                  = "${var.vpc_cidr}"
  vpc_id                    = "${module.network.vpc_id}"
  ecs_cluster_name          = "${var.ecs_cluster_name}"
  project_accronym          = "${var.project_accronym}"
  default_tags              = "${var.default_tags}"
  key_name                  = "${var.key_name}"
  ecs_node_instance_type    = "t2.micro"
  ecs_node_instance_count   = 2
  ecs_instance_role_name    = "ECSInstanceRole"
  services_subnets          = "${module.network.svc_subnet_ids}"
  dmz_subnets               = "${module.network.dmz_subnet_ids}"
}

module "services" {
  source = "../../modules/services"

  vpc_id                    = "${module.network.vpc_id}"
  project_accronym          = "${var.project_accronym}"
  default_tags              = "${var.default_tags}"
  cluster_id                = "${module.ecs_cluster.ecs_cluster_id }"
  alb_http_listener_arn     = "${module.ecs_cluster.alb_http_listener_arn}"
  ecs_service_role_arn      = "arn:aws:iam::408673749050:role/ECSServiceRole"
  alb_arn                   = "${module.ecs_cluster.alb_arn}"
}
