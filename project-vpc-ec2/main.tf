# Creating VPC
resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
}

#Creating Subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.cidr_block_pub_subnet
  availability_zone       = var.pub_sub_avl_zone
  map_public_ip_on_launch = var.public_ip_on_launch_bool
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.cidr_block_pub_subnet1
  availability_zone       = var.pub_sub1_avl_zone
  map_public_ip_on_launch = var.public_ip_on_launch_bool
}

#Creating Internet Gateway
resource "aws_internet_gateway" "myvpc_igw" {
  vpc_id = aws_vpc.myvpc.id
}

#Creating Route Tables
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = var.route_table_cidr_block
    gateway_id = aws_internet_gateway.myvpc_igw.id
  }
}

#Creating Subnet Association
resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

#Creating Security Groups
resource "aws_security_group" "webSg" {
  name   = "web"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = var.sg_ingress_desc
    from_port   = var.sg_ingress_from_port
    to_port     = var.sg_ingress_to_port
    protocol    = var.sg_ingress_protocol
    cidr_blocks = var.sg_ingress_cidr_block
  }
  ingress {
    description = var.sg_ingress_one_desc
    from_port   = var.sg_ingress_one_from_port
    to_port     = var.sg_ingress_one_to_port
    protocol    = var.sg_ingress_one_protocol
    cidr_blocks = var.sg_ingress_one_cidr_block
  }

  egress {
    from_port   = var.sg_egress_from_port
    to_port     = var.sg_egress_to_port
    protocol    = var.sg_egress_protocol
    cidr_blocks = var.sg_egress_cidr_block
  }

  tags = {
    Name = var.sg_tags_name
  }
}

# Creating S3 Bucket
resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = var.s3_bucket_name
}

# Creating Ec2-instance with the VPC
resource "aws_instance" "webserver1" {
  ami                    = var.ec2_frst_instance_name
  instance_type          = var.ec2_frst_instance_type
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.public_subnet_1.id
  user_data              = base64encode(file("userdata.sh"))
}

resource "aws_instance" "webserver2" {
  ami                    = var.ec2_scnd_instance_name
  instance_type          = var.ec2_scnd_instance_type
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.public_subnet_2.id
  user_data              = base64encode(file("userdata1.sh"))
}

#create alb
resource "aws_lb" "myalb" {
  name               = var.myload_blncr_name
  internal           = var.myload_blncr_internal
  load_balancer_type = var.myload_blncr_type

  security_groups = [aws_security_group.webSg.id]
  subnets         = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  tags = {
    Name = var.myload_blncr_tags_name
  }
}

# Creating Load Balancer
resource "aws_lb_target_group" "web_target_group" {
  name     = var.tg_name
  port     = var.tg_port
  protocol = var.tg_protocol
  vpc_id   = aws_vpc.myvpc.id

  health_check {
    path = var.tg_health_check_path
    port = var.tg_health_check_port
  }
}

# Attaching Load Balancer
resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.web_target_group.arn
  target_id        = aws_instance.webserver1.id
  port             = var.aws_lb_tg_attach_port
}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.web_target_group.arn
  target_id        = aws_instance.webserver2.id
  port             = var.aws_lb_tg_attach_one_port
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.myalb.arn
  port              = var.aws_lb_listnr_port
  protocol          = var.aws_lb_listnr_protocol

  default_action {
    target_group_arn = aws_lb_target_group.web_target_group.arn
    type             = var.aws_lb_listnr_def_actn_type
  }
}
