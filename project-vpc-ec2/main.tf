# Creating VPC
resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
}

#Creating Subnets
resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.cidr_block_pub_subnet
  availability_zone       = var.pub_sub_avl_zone
  map_public_ip_on_launch = var.public_ip_on_launch_bool
}

resource "aws_subnet" "sub2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.cidr_block_pub_subnet1
  availability_zone       = var.pub_sub1_avl_zone
  map_public_ip_on_launch = var.public_ip_on_launch_bool
}

#Creating Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

#Creating Route Tables
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = var.route_table_cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }
}

#Creating Subnet Association
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.RT.id
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
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-sg"
  }
}

# Creating S3 Bucket
resource "aws_s3_bucket" "example" {
  bucket = "terraform-s3-test-reya-project"
}

# Creating Ec2-instance with the VPC
resource "aws_instance" "webserver1" {
  ami                    = "ami-02b8269d5e85954ef"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.sub1.id
  user_data              = base64encode(file("userdata.sh"))
}

resource "aws_instance" "webserver2" {
  ami                    = "ami-02b8269d5e85954ef"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.sub2.id
  user_data              = base64encode(file("userdata1.sh"))
}

#create alb
resource "aws_lb" "myalb" {
  name               = "myalb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.webSg.id]
  subnets         = [aws_subnet.sub1.id, aws_subnet.sub2.id]

  tags = {
    Name = "web"
  }
}

# Creating Load Balancer
resource "aws_lb_target_group" "tg" {
  name     = "myTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.myvpc.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

# Attaching Load Balancer
resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver2.id
  port             = 80
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.myalb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type             = "forward"
  }
}

output "loadbalancerdns" {
  value = aws_lb.myalb.dns_name
}
