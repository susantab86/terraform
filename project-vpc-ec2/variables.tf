variable "aws_region" {
  description = "AWS region for resource deployment"
  type        = string
}

variable "cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "cidr_block_pub_subnet" {
type  = string 
}

variable "pub_sub_avl_zone" {
type =  string
}

varibale "cidr_block_pub_subnet1" {
type = string
}

varibale "pub_sub1_avl_zone" {
type = string 
}

variable "public_ip_on_launch_bool" {
type = bool
}

variable "route_table_cidr_block" {
type = string
}

variable "sg_ingress_desc" {
type  =  string 
}

variable "sg_ingress_from_port" {
type = number
}

variable "sg_ingress_to_port" {
type = number
}

variable "sg_ingress_protocol" {
type = string 
}

variable "sg_ingress_cidr_block" {
 type = list(string)
}

variable "sg_ingress_one_desc" {
type  =  string 
}

variable "sg_ingress_one_from_port" {
type = number
}

variable "sg_ingress_one_to_port" {
type = number
}

variable "sg_ingress_one_protocol" {
type = string 
}

variable "sg_ingress_one_cidr_block" {
 type = list(string)
}

variable "sg_egress_from_port" {
type = number
}

variable "sg_egress_protocol" {
type = string
}

variable "sg_egress_cidr_block" {
 type = list(string)
}

variable  "sg_tags_name" {
type = string 
}

variable "s3_bucket_name" {
type = string
}

variable "s3_bucket_region" {
type = string
}

variable "ec2_frst_instance_name" {
type = string
}

variable "ec2_frst_instance_type" {
type = string
}

variable "ec2_scnd_instance_name" {
type = string
}

variable "ec2_scnd_instance_type" {
type = string
}

variable "myload_blncr_name" {
type = string
}

variable "myload_blncr_internal" {
type = bool
}

variable "myload_blncr_type" {
type = string
}

variable "myload_blncr_tags_name" {
type = string
}

variable "tg_name" {
type = string
}

variable "tg_port" {
type = number
}

variable "tg_protocol" {
type = string
}

variable "tg_health_check_path" {
type = string
}

variable "tg_health_check_port" {
type = string
}

variable "aws_lb_tg_attach_port" {
type = number
}

variable "aws_lb_tg_attach_one_port" {
type = number
}

variable "aws_lb_listnr_port" {
type = number
}

variable "aws_lb_listnr_protocol" {
type = string
}

variable "aws_lb_listnr_def_actn_type" {
type = string
}



















