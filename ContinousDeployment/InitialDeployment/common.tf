variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}

variable "project_name" {
  default = "BeePower"
}

variable "project_accronym" {
  default = "BP"
}

variable "environment" {
  default = "DEV"
}

variable "key_name" {
  default = "DTL-SYD-SERVERS"
}

variable "ecs_cluster_name" {
  default = "BP_DEV_Cluster"
}

variable "ecs_instance_role_name" {
  default = "ECSInstanceRole"
}

variable "ecs_service_role_arn" {
  default = "arn:aws:iam::408673749050:role/ECSServiceRole"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "ap-southeast-2"
}
