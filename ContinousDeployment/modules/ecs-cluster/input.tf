variable "ecs_cluster_name" {}
variable "project_accronym" {}
variable "vpc_cidr" {}
variable "vpc_id" {}
variable "ecs_node_instance_type" {}
variable "ecs_node_instance_count" {}
variable "ecs_instance_role_name" {}
variable "key_name" {}
variable "services_subnets" { type = "list"}
variable "dmz_subnets" { type = "list"}
variable "default_tags" { type = "map" }
