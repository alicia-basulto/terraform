variable "server_port" {
 description = "The port to EC2 instance"
 type = "number"
}

variable "lb_port" {
 description = "The port to ALB"
 type = "number"
}

variable "instance_type" {
 description = "Type of EC2 instance"
 type = "string"
}