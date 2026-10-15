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


