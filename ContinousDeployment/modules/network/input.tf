variable "vpc_cidr" {}
variable "project_accronym" {}
variable "default_tags" { type = "map" }
variable "key_name" {}
variable "dmz_cidrs" { type = "list" }
variable "services_subnet_cidrs" { type = "list" }
variable "required_az_count" {}
variable "availability_zones" { type = "list" }
