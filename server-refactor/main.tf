# ---------------------
# Define AWS PROVIDER
# --------------------
provider "aws" {
    region = local.region

}



locals {
  region ="eu-west-1"
}


data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "public_subnet"{
  for_each = var.servers
  availability_zone = "${local.region}${each.value.az}"
}
 
# ---------------------
# Define EC2 instances with AMI Ubuntu
# --------------------
resource "aws_instance" "server" {
  for_each = var.servers
    ami            = "ami-0694d931cee176e7d"
    instance_type = "t2.micro"
    subnet_id = data.aws_subnet.public_subnet[each.key].id
    vpc_security_group_ids = [aws_security_group.mi_grupo_de_seguridad.id]
    user_data = <<-EOF
              #!/bin/bash
              echo "Hi! I'm the server number 1 Terraformer!" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF
  tags = {
    Name = each.value.name
  }

}


# Application Load Balancer

resource "aws_lb" "alb" {
  load_balancer_type = "application"
  name = "terraformers-alb"
  security_groups =  [aws_security_group.alb.id]
  subnets = [for subnet in data.aws_subnet.public_subnet : subnet.id]

}

# Security Group for ALB

resource "aws_security_group" "alb" {
  name   = "alb-sg"
  vpc_id = data.aws_vpc.default.id
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Acceso al puerto 80 desde el exterior"
    from_port   = var.lb_port
    to_port     = var.lb_port
    protocol    = "TCP"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Acceso al puerto 8080 de nuestros servidores"
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "TCP"
  }
}
resource "aws_lb_target_group" "this" {
  name = "terraformers-alb-target-group"
  port = var.lb_port
  vpc_id = data.aws_vpc.default.id
  protocol = "HTTP"
  health_check {
    enabled = true
    matcher = 200
    port = var.server_port
    protocol = "HTTP"
    path = "/"

  }

  
}

# Security Group for EC2 instances

resource "aws_security_group" "mi_grupo_de_seguridad" {
  name   = "primer-servidor-sg"
  vpc_id = data.aws_vpc.default.id
  ingress {
    security_groups = [aws_security_group.alb.id]
    description = "Acceso al puerto 8080 desde el exterior"
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "TCP"
  }
}

# Load Balancer Target Group Attachment

resource "aws_lb_target_group_attachment" "server_attachment" {
  for_each = var.servers
  target_group_arn = aws_lb_target_group.this.arn
  target_id = aws_instance.server[each.key].id
  port = var.server_port
  
}


#Load Balancer Listener

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.alb.arn
  port = var.lb_port
  protocol = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.this.arn
    type = "forward"
  }
  
}


