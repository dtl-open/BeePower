variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}

variable "default_tags" {
  type = "map"
  default = {
      project_name      = "BeePower"
      environment       = "DEV"
  }
}

variable "project_accronym" {
    default = "BP"
}

variable "key_name" {
  default = "DTL-SYD-SERVERS"
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "dmz_subnet_cidrs" {
    type    = "list"
    default = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "services_subnet_cidrs" {
    type    = "list"
    default = ["10.0.3.0/24", "10.0.4.0/24"]
}
variable "required_az_count" {
    default = 2
}

variable "ecs_cluster_name" {
    default = "BP_DEV_CLUSTER"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "ap-southeast-2"
}

# Keep eye on https://github.com/hashicorp/terraform/issues/13589
# Due to this issue, if you use s3 backend you have to append
# AWS_PROFILE=dtl-cd (aws profile) to every terraform command.
# Otherwise terraform taskes to default aws profile. Ex.
# - AWS_PROFILE=dtl-cd terraform init
# - AWS_PROFILE=dtl-cd terraform plan
# - AWS_PROFILE=dtl-cd terraform apply

terraform {
  backend "s3" {
    bucket  = "bee-power"
    key     = "dev/terraform.state"
    region  = "ap-southeast-2"
    profile = "dtl-cd"
  }
}
