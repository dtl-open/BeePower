variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "ecs_cluster_id" {
  default = "arn:aws:ecs:ap-southeast-2:408673749050:cluster/BP_DEV_Cluster"
}

variable "ecs_service_iam_role" {
  default = "arn:aws:iam::408673749050:role/ECSServiceRole"
}

variable "alb_target_group_meter_reads_arn" {
  default = "arn:aws:elasticloadbalancing:ap-southeast-2:408673749050:targetgroup/BP-MeterReads-TG/8894fb8b59e56290"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "ap-southeast-2"
}
